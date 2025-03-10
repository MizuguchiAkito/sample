variable "prefix_name" {
  type        = string
  description = "tag:Nameの前に付くprefix"
  validation {
    condition     = can(regex("faas\\-[a-z][0-9]+", var.prefix_name))
    error_message = "The prefix_name value must be a valid pattern that starting with \"fass-\" and your ID."
  }
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "ParameterStoreで利用する環境名、slsのparams:envと合わせる"
}

variable "github_owner" {
  default     = ""
  type        = string
  description = "GitHubのアカウント名"
}

variable "github_repo" {
  default     = ""
  type        = string
  description = "GitHubに作成したリポジトリ名"
}
