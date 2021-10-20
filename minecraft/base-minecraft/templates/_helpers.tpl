// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if eq .minecraft.job_name "" -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .minecraft.job_name | quote -]]
[[- end -]]
[[- end -]]

// only deploys to a region if specified

[[- define "region" -]]
[[- if not (eq .minecraft.region "") -]]
region = [[ .minecraft.region | quote]]
[[- end -]]
[[- end -]]