# Configuration
Replace configuration values from `sample_config.xml` with your own values in a file called `config.xml` in the same directory.

#### token
You can find your token by going to [Facebook's dev explorer page](https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0) and clicking "Get Token".  Be sure to check `read_mailbox` under "Extended Permissions"

#### conversation_id
You can find a conversation's id by going to your [Facebook messages](https://www.facebook.com/messages/) and selecting the desired group converation.
The `conversation_id` will be in the url: `https://www.facebook.com/messages/conversation-<conversation_id>`

#### open_browser
If this is set to `TRUE`, when running `get_comments`, the script will open a browser to the Facebook dev explorer page if the access token session has expired.