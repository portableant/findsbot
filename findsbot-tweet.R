# Create Twitter token
findsbot_token <- rtweet::create_token(
  app = "findsbot",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

randomFinds <- fromJSON("https://finds.org.uk/database/search/results/q/*:*/sort/random_/show/1/thumbnail/1/format/json")
id <- randomFinds$results$id
url <- paste0('https://finds.org.uk/database/artefacts/record/id', id)
period <- randomFinds$results$broadperiod
objectType <- randomFinds$results$objecttype
county <- randomFinds$results$county
oldFindID <- randomFinds$results$old_findID
imagedir <- randomFinds$results$imagedir
image <- randomFinds$results$filename
imageUrl <- paste0('https://finds.org.uk/', imagedir, image)

tweet <- paste(period,objectType,'from',county,oldFindID,url, sep=' ')
temp_file <- tempfile()
download.file(imageUrl, temp_file)

rtweet::post_tweet(
  status = tweet,
  media = temp_file,
  token = findsbot_token
)
