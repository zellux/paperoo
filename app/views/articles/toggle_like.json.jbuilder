json.status @status
json.current @article.likes do |json, like|
  json.username like.account.username
end
