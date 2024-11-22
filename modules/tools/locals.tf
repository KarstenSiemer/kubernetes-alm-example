locals {
  install_env_cluster      = var.env != "tools"
  install_tools_cluster    = var.env == "tools"
  service_monitor_selector = {}
  cluster_credentials = { for k, v in var.clusters : k => {
    name    = k
    project = v.env
    server  = v.host
    labels = {
      (v.env) = "true"
      env     = "true"
      http    = tostring(v.http)
      https   = tostring(v.https)
    }
    config = {
      tlsClientConfig = {
        insecure = false
        caData   = base64encode(v.ca_data)
        certData = base64encode(v.cert_data)
        keyData  = base64encode(v.key_data)
      }
    }
  } if k != "tools" }
  repositories = { for k, v in var.repositories : nonsensitive(k) => merge(
    {
      name = nonsensitive(k)
      url  = nonsensitive(v.url),
    },
    length(v.project) > 0 ? {
      project = nonsensitive(v.project),
    } : {},
    length(v.type) > 0 ? {
      type = nonsensitive(v.type),
    } : {},
    length(v.username) > 0 ? {
      username = nonsensitive(v.username),
    } : {},
    length(v.type) > 0 ? {
      enableOCI = v.type == "helm" ? "true" : "false"
    } : {},
    )
  }

  projects = { for k in keys(var.envs) : k => {
    roles       = []
    namespace   = "argocd"
    description = "Project of ${k}"
    sourceRepos = ["*"]
    destinations = [
      {
        name      = "*"
        server    = "*"
        namespace = "*"
      },
    ]
    additionalLabels = {
      env = k
    }
    clusterResourceWhitelist = [
      {
        group = ""
        kind  = "Namespace"
      }
    ]
    namespaceResourceBlacklist = [
      {
        group = "argoproj.io"
        kind  = "AppProject"
      }
    ]
    orphanedResources = {
      warn = true
    }
    permitOnlyProjectScopedClusters = k != "tools" ? true : false
  } }

  applications = { "seeder" = {
    namespace = "argocd"
    project   = "tools"
    source = {
      repoURL        = "git@github.com:KarstenSiemer/BMMI.git"
      targetRevision = "main"
      path           = "deploy/"
    }
    destination = {
      name      = "in-cluster"
      namespace = "argocd"
    }
    syncPolicy = {
      automated = {
        prune    = true
        selfHeal = true
      }
    }
  } }

  notifications_app_enabled = alltrue([for v in [var.github_app_id, var.github_app_installation_id, var.github_app_private_key] : length(v) > 0])

  notifications_notifiers = local.notifications_app_enabled ? {
    "service.github" = <<-EOF
      appID: ${var.github_app_id}
      installationID: ${var.github_app_installation_id}
      privateKey: $github-app-privateKey
    EOF
  } : {}

  notifications_triggers = {
    "trigger.on-created"             = <<-EOF
      - description: Application is created.
        oncePer: app.metadata.name
        send:
        - app-created
        when: "true"
    EOF
    "trigger.on-deleted"             = <<-EOF
      - description: Application is deleted.
        oncePer: app.metadata.name
        send:
        - app-deleted
        when: app.metadata.deletionTimestamp != nil
    EOF
    "trigger.on-deployed"            = <<-EOF
      - description: Application is synced and healthy. Triggered once per commit.
        oncePer: app.status.operationState?.syncResult?.revision
        send:
        - app-deployed
        when: app.status.operationState != nil and app.status.operationState.phase in ['Succeeded']
          and app.status.health.status == 'Healthy'
    EOF
    "trigger.on-pr"                  = <<-EOF
      - description: Application is synced and healthy. Triggered once per commit.
        oncePer: app.status.operationState?.syncResult?.revision
        send:
        - app-pr
        when: app.status.operationState != nil and app.status.operationState.phase in ['Succeeded']
          and app.status.health.status == 'Healthy'
    EOF
    "trigger.on-health-degraded"     = <<-EOF
      - description: Application has degraded
        send:
        - app-health-degraded
        when: app.status.health.status == 'Degraded'
    EOF
    "trigger.on-sync-failed"         = <<-EOF
      - description: Application syncing has failed
        send:
        - app-sync-failed
        when: app.status.operationState != nil and app.status.operationState.phase in ['Error',
          'Failed']
    EOF
    "trigger.on-sync-running"        = <<-EOF
      - description: Application is being synced
        send:
        - app-sync-running
        when: app.status.operationState != nil and app.status.operationState.phase in ['Running']
    EOF
    "trigger.on-sync-status-unknown" = <<-EOF
      - description: Application status is 'Unknown'
        send:
        - app-sync-status-unknown
        when: app.status.sync.status == 'Unknown'
    EOF
  }

  notifications_subscriptions_defaults = [
    {
      recipients = [
        "github"
      ]
      triggers = [for k, v in local.notifications_triggers : replace(k, "trigger.", "")]
    }
  ]

  notifications_templates_label      = "argocd/{{.app.metadata.name}}"
  notifications_templates_target_url = "{{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true"
  notifications_templates = {
    "template.app-deployed"            = <<-EOF
      message: |
        Application {{.app.metadata.name}} is now running with {{ .app.status.sync.revision }} of deployments manifests.
      github:
        status:
          state: success
          label: "${local.notifications_templates_label}"
          targetURL: "${local.notifications_templates_target_url}"
        pullRequestComment:
          content: |
            Application {{.app.metadata.name}} is now running {{ .app.status.sync.revision }} of deployments manifests.
            See more here: ${local.notifications_templates_target_url}
    EOF
    "template.app-pr"                  = <<-EOF
      message: |
        Application reconcilation was successful.
      github:
        status:
          state: success
          label: "argocd/app"
    EOF
    "template.app-created"             = <<-EOF
      message: |
        Application {{.app.metadata.name}} is created.
      github:
        status:
          state: success
          label: "${local.notifications_templates_label}/created"
          targetURL: "${local.notifications_templates_target_url}"
    EOF
    "template.app-deleted"             = <<-EOF
      message: |
        Application {{.app.metadata.name}} is deleted.
      github:
        status:
          state: success
          label: "${local.notifications_templates_label}/deleted"
          targetURL: "${local.notifications_templates_target_url}"
        pullRequestComment:
          content: |
            Application {{.app.metadata.name}} has been deleted.
    EOF
    "template.app-sync-failed"         = <<-EOF
      message: |
        The sync operation of application {{.app.metadata.name}} has failed at {{.app.status.operationState.finishedAt}} with the following error: {{.app.status.operationState.message}}
      github:
        status:
          state: failure
          label: "${local.notifications_templates_label}"
          targetURL: "${local.notifications_templates_target_url}"
        pullRequestComment:
          content: |
            The sync operation of application {{.app.metadata.name}} has failed at {{.app.status.operationState.finishedAt}} with the following error: {{.app.status.operationState.message}}
    EOF
    "template.app-sync-running"        = <<-EOF
      message: |
        The sync operation of application {{.app.metadata.name}} has started at {{.app.status.operationState.startedAt}}.
      github:
        status:
          state: pending
          label: "${local.notifications_templates_label}"
          targetURL: "${local.notifications_templates_target_url}"
    EOF
    "template.app-sync-status-unknown" = <<-EOF
      message: |
        Application {{.app.metadata.name}} sync is 'Unknown'.
      github:
        status:
          state: failure
          label: "${local.notifications_templates_label}"
          targetURL: "${local.notifications_templates_target_url}"
    EOF
    "template.app-health-degraded"     = <<-EOF
      message: |
        Application {{.app.metadata.name}} is degraded.
      github:
        status:
          state: failure
          label: "${local.notifications_templates_label}"
          targetURL: "${local.notifications_templates_target_url}"
    EOF
  }

  prometheus_remote_write_fqdn   = join("", ["prometheus.", var.prometheus_remote_write_target, replace(var.domain, "127.0.0.1", "")])
  prometheus_remote_write_target = join("", ["http://", local.prometheus_remote_write_fqdn, ":", var.envs.tools.nodePortHttp, "/api/v1/write"])
}
