variable "prefix_name" {
  type        = string
  nullable    = false
  description = "tag:Nameの前に付くprefix"
}

variable "region" {
  type        = string
  nullable    = false
  description = "使用するリージョン"
}

variable "availability_zone" {
  type        = string
  nullable    = false
  description = "使用するアベイラビリティーゾーン"
}

variable "vpc_cidr" {
  type        = string
  nullable    = false
  description = "VPCで使用するCIDR"
}

variable "subnet_cidr" {
  type        = string
  nullable    = false
  description = "サブネットに設定するCIDR"
}

variable "runners_name" {
  default     = "gitlab runner of docker in docker"
  type        = string
  nullable    = false
  description = "gitlab runnerの名前"
}


variable "runners_gitlab_url" {
  type        = string
  description = "gitlab runnerのURL"
  nullable    = false
}


variable "runners_concurrent" {
  default     = 1
  type        = number
  description = "並列に動作可能なjob数"
}


variable "runners_check_interval" {
  default     = 5
  type        = number
  description = "新しいjobをチェックする間隔(秒)"
}


variable "runners_shm_size" {
  default     = 0
  type        = number
  description = "runnerのshm_size"
}

variable "gitlab_runner_token" {
  description = "GitLab runnerのregister時に使うtoken"
  type        = string
  nullable    = false
}
