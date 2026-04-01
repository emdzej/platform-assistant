{{/*
Expand the name of the chart.
*/}}
{{- define "platform-assistant.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "platform-assistant.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "platform-assistant.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-assistant.labels" -}}
helm.sh/chart: {{ include "platform-assistant.chart" . }}
{{ include "platform-assistant.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.opencode.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: platform-assistant
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-assistant.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
OpenCode component labels
*/}}
{{- define "platform-assistant.opencode.labels" -}}
{{ include "platform-assistant.labels" . }}
app.kubernetes.io/component: opencode
{{- end }}

{{- define "platform-assistant.opencode.selectorLabels" -}}
{{ include "platform-assistant.selectorLabels" . }}
app.kubernetes.io/component: opencode
{{- end }}

{{/*
ArgoCD MCP component labels
*/}}
{{- define "platform-assistant.argocd.labels" -}}
{{ include "platform-assistant.labels" . }}
app.kubernetes.io/component: argocd-mcp
{{- end }}

{{- define "platform-assistant.argocd.selectorLabels" -}}
{{ include "platform-assistant.selectorLabels" . }}
app.kubernetes.io/component: argocd-mcp
{{- end }}

{{/*
ArgoCD MCP fullname
*/}}
{{- define "platform-assistant.argocd.fullname" -}}
{{- printf "%s-argocd-mcp" (include "platform-assistant.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
OpenCode fullname
*/}}
{{- define "platform-assistant.opencode.fullname" -}}
{{- printf "%s-opencode" (include "platform-assistant.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Kubernetes MCP service URL — resolves the subchart service name.
The subchart uses its own fullname, which for an aliased dependency is:
  <release>-<alias>
*/}}
{{- define "platform-assistant.kubernetesMcp.url" -}}
http://{{ .Release.Name }}-kubernetes-mcp-server:{{ .Values.kubernetesMcp.service.port }}/mcp
{{- end }}

{{/*
ArgoCD MCP service URL
*/}}
{{- define "platform-assistant.argocd.url" -}}
http://{{ include "platform-assistant.argocd.fullname" . }}:{{ .Values.argocd.service.port }}/mcp
{{- end }}

{{/*
RagClaw MCP service URL
*/}}
{{- define "platform-assistant.ragclawMcp.url" -}}
http://{{ .Release.Name }}-ragclaw-mcp:{{ .Values.ragclawMcp.service.port | default 3000 }}/mcp
{{- end }}

{{/*
Ollama service URL
*/}}
{{- define "platform-assistant.ollama.url" -}}
http://{{ .Release.Name }}-ollama:{{ .Values.ollama.service.port | default 11434 }}/v1/
{{- end }}

{{/*
OpenCode provider secret name for a given provider.
Returns existingSecret if set, otherwise the chart-managed secret name.
Usage: include "platform-assistant.providerSecretName" (dict "provider" .Values.opencode.providers.anthropic "name" "anthropic" "fullname" (include "platform-assistant.fullname" .))
*/}}
{{- define "platform-assistant.providerSecretName" -}}
{{- if .provider.existingSecret }}
{{- .provider.existingSecret }}
{{- else }}
{{- printf "%s-%s" .fullname .name }}
{{- end }}
{{- end }}

{{/*
ArgoCD secret name
*/}}
{{- define "platform-assistant.argocd.secretName" -}}
{{- if .Values.argocd.existingSecret }}
{{- .Values.argocd.existingSecret }}
{{- else }}
{{- include "platform-assistant.argocd.fullname" . }}
{{- end }}
{{- end }}
