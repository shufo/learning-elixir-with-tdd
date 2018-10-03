alias PhoenixApi101Web.Endpoint
alias PhoenixApi101.Repo
import Ecto
import Ecto.Query

alias PhoenixApi101.Accounts.User
alias PhoenixApi101.Blogs.Post
alias PhoenixApi101.ElasticsearchCluster

IEx.configure(
  alive_prompt: "%prefix(%node):%counter>",
  colors: [eval_result: [:green]],
  default_prompt: "%prefix:%counter>",
  inspect: [pretty: true, char_lists: :as_lists, limit: :infinity],
)

