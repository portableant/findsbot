library(httr)
library(rtweet)
library(jsonlite)
library(digest)
# Create Twitter token
findsbot_token <- rtweet::rtweet_bot(
  api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)
hash <- digest(Sys.time(),algo="md5", serialize=TRUE)
search <- paste0('https://finds.org.uk/database/search/results/q/*:*/sort/random_', hash,'/show/1/thumbnail/1/format/json')
randomFinds <- fromJSON(search)
id <- randomFinds$results$id
url <- paste0('https://finds.org.uk/database/artefacts/record/id/', id)
period <- randomFinds$results$broadperiod
periodHash <- gsub(" ", "", period, fixed = TRUE)
periodHash <- paste0('#', periodHash)
objectType <- randomFinds$results$objecttype
county <- randomFinds$results$county
oldFindID <- randomFinds$results$old_findID
imagedir <- randomFinds$results$imagedir
image <- randomFinds$results$filename
imageUrl <- paste0('https://finds.org.uk/', imagedir, URLencode(image))
hashtag <- '#findsorguk #recordYourFinds'
tweet <- paste(period,objectType,'from',county,oldFindID,url,hashtag, periodHash, sep=' ')
temp_file <- tempfile(fileext = ".jpeg")
download.file(imageUrl, temp_file)

rtweet::post_tweet(
  status = tweet,
  media = temp_file,
  token = findsbot_token,
  media_alt_text = tweet
)
