{
    See the file LICENSE, included in this distribution,
    for details about the copyright.
}

unit TelegramApi;

interface

uses Math, HTTPSend, Classes, StrUtils, ssl_openssl, synautil, SysUtils,
  fpjson, jsonparser;

type

  PUpdate = ^TUpdate;
  PUser = ^TUser;
  PChat = ^TChat;
  PMessage = ^TMessage;
  PMessageEntity = ^TMessageEntity;
  PPhotoSize = ^TPhotoSize;
  PAudio = ^TAudio;
  PDocument = ^TDocument;
  PSticker = ^TSticker;
  PVideo = ^TVideo;
  PVoice = ^TVoice;
  PContact = ^TContact;
  PLocation = ^TLocation;
  PVenue = ^TVenue;
  PUserProfilePhotos = ^TUserProfilePhotos;
  PFile = ^TFile;
  PReplyKeyboardMarkup = ^TReplyKeyboardMarkup;
  PKeyboardButton = ^TKeyboardButton;
  PReplyKeyboardHide = ^TReplyKeyboardHide;
  PInlineKeyboardMarkup = ^TInlineKeyboardMarkup;
  PInlineKeyboardButton = ^TInlineKeyboardButton;
  PCallbackQuery = ^TCallbackQuery;
  PForceReply = ^TForceReply;
  PInlineQuery = ^TInlineQuery;
  PInlineQueryResult = ^TInlineQueryResult;
  PInlineQueryResultArticle = ^TInlineQueryResultArticle;
  PInlineQueryResultPhoto = ^TInlineQueryResultPhoto;
  PInlineQueryResultGif = ^TInlineQueryResultGif;
  PInlineQueryResultMpeg4Gif = ^TInlineQueryResultMpeg4Gif;
  PInlineQueryResultVideo = ^TInlineQueryResultVideo;
  PInlineQueryResultAudio = ^TInlineQueryResultAudio;
  PInlineQueryResultVoice = ^TInlineQueryResultVoice;
  PInlineQueryResultDocument = ^TInlineQueryResultDocument;
  PInlineQueryResultLocation = ^TInlineQueryResultLocation;
  PInlineQueryResultVenue = ^TInlineQueryResultVenue;
  PInlineQueryResultContact = ^TInlineQueryResultContact;
  PInlineQueryResultCachedPhoto = ^TInlineQueryResultCachedPhoto;
  PInlineQueryResultCachedGif = ^TInlineQueryResultCachedGif;
  PInlineQueryResultCachedMpeg4Gif = ^TInlineQueryResultCachedMpeg4Gif;
  PInlineQueryResultCachedSticker = ^TInlineQueryResultCachedSticker;
  PInlineQueryResultCachedDocument = ^TInlineQueryResultCachedDocument;
  PInlineQueryResultCachedVideo = ^TInlineQueryResultCachedVideo;
  PInlineQueryResultCachedVoice = ^TInlineQueryResultCachedVoice;
  PInlineQueryResultCachedAudio = ^TInlineQueryResultCachedAudio;
  PInputMessageContent = ^TInputMessageContent;
  PInputTextMessageContent = ^TInputTextMessageContent;
  PInputLocationMessageContent = ^TInputLocationMessageContent;
  PInputVenueMessageContent = ^TInputVenueMessageContent;
  PInputContactMessageContent = ^TInputContactMessageContent;
  PChosenInlineResult = ^TChosenInlineResult;

  TUpdate = record
    // This Pobject represents an incoming update.Only one of the optional parameters can be present in any given update.

    update_id: integer;
    //The update‘s unique identifier. Update identifiers start from a certain positive number and increase sequentially. This ID becomes especially handy if you’re using PWebhooks, since it allows you to ignore repeated updates or to restore the correct update sequence, should they get out of order.
    message: PMessage;
    //Optional. New incoming message of any kind — text, photo, sticker, etc.
    inline_query: PInlineQuery; //Optional. New incoming Pinline query
    chosen_inline_result: PChosenInlineResult;
    //Optional. The result of an Pinline query that was chosen by a user and sent to their chat partner.
    callback_query: PCallbackQuery; //Optional. New incoming callback query

  end;


  TUser = record // This object represents a Telegram user or bot.

    id: integer; //Unique identifier for this user or bot
    first_name: string; //User‘s or bot’s first name
    last_name: string; //Optional. User‘s or bot’s last name
    username: string; //Optional. User‘s or bot’s username

  end;


  TChat = record // This object represents a chat.

    id: integer; //Unique identifier for this chat, not exceeding 1e13 by absolute value
    _type: string;
    //Type of chat, can be either “private”, “group”, “supergroup” or “channel”
    title: string; //Optional. Title, for channels and group chats
    username: string;
    //Optional. Username, for private chats, supergroups and channels if available
    first_name: string; //Optional. First name of the other party in a private chat
    last_name: string; //Optional. Last name of the other party in a private chat

  end;


  TMessage = record // This object represents a message.

    message_id: integer; //Unique message identifier
    from: PUser; //Optional. Sender, can be empty for messages sent to channels
    date: integer; //Date the message was sent in Unix time
    chat: PChat; //Conversation the message belongs to
    forward_from: PUser;
    //Optional. For forwarded messages, sender of the original message
    forward_from_chat: PChat;
    //Optional. For messages forwarded from a channel, information about the original channel
    forward_date: integer;
    //Optional. For forwarded messages, date the original message was sent in Unix time
    reply_to_message: PMessage;
    //Optional. For replies, the original message. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.
    Text: string;
    //Optional. For text messages, the actual UTF-8 text of the message, 0-4096 characters.
    entities: array of PMessageEntity;
    //Optional. For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text
    audio: PAudio; //Optional. Message is an audio file, information about the file
    document: PDocument; //Optional. Message is a general file, information about the file
    photo: array of PPhotoSize;
    //Optional. Message is a photo, available sizes of the photo
    sticker: PSticker; //Optional. Message is a sticker, information about the sticker
    video: PVideo; //Optional. Message is a video, information about the video
    voice: PVoice; //Optional. Message is a voice message, information about the file
    Caption: string; //Optional. Caption for the document, photo or video, 0-200 characters
    contact: PContact;
    //Optional. Message is a shared contact, information about the contact
    location: PLocation;
    //Optional. Message is a shared location, information about the location
    venue: PVenue; //Optional. Message is a venue, information about the venue
    new_chat_member: PUser;
    //Optional. A new member was added to the group, information about them (this member may be the bot itself)
    left_chat_member: PUser;
    //Optional. A member was removed from the group, information about them (this member may be the bot itself)
    new_chat_title: string; //Optional. A chat title was changed to this value
    new_chat_photo: array of PPhotoSize;
    //Optional. A chat photo was change to this value
    delete_chat_photo: boolean; //Optional. Service message: the chat photo was deleted
    group_chat_created: boolean; //Optional. Service message: the group has been created
    supergroup_chat_created: boolean;
    //Optional. Service message: the supergroup has been created
    channel_chat_created: boolean;
    //Optional. Service message: the channel has been created
    migrate_to_chat_id: integer;
    //Optional. The group has been migrated to a supergroup with the specified identifier, not exceeding 1e13 by absolute value
    migrate_from_chat_id: integer;
    //Optional. The supergroup has been migrated from a group with the specified identifier, not exceeding 1e13 by absolute value
    pinned_message: PMessage;
    //Optional. Specified message was pinned. Note that the Message object in this field will not contain further reply_to_message fields even if it is itself a reply.

  end;


  TMessageEntity = record
    // This object represents one special entity in a text message. For example, hashtags, usernames, URLs, etc.

    _type: string;
    //Type of the entity. One of mention (@username), hashtag, bot_command, url, email, bold (bold text), italic (italic text), code (monowidth string), pre (monowidth block), text_link (for clickable text URLs)
    offset: integer; //Offset in UTF-16 code units to the start of the entity
    length: integer; //Length of the entity in UTF-16 code units
    url: string;
    //Optional. For “text_link” only, url that will be opened after user taps on the text

  end;


  TPhotoSize = record
    // This object represents one size of a photo or a Pfile / Psticker thumbnail.

    file_id: string; //Unique identifier for this file
    Width: integer; //Photo width
    Height: integer; //Photo height
    file_size: integer; //Optional. File size

  end;


  TAudio = record
    // This object represents an audio file to be treated as music by the Telegram clients.

    file_id: string; //Unique identifier for this file
    duration: integer; //Duration of the audio in seconds as defined by sender
    performer: string;
    //Optional. Performer of the audio as defined by sender or by audio tags
    title: string; //Optional. Title of the audio as defined by sender or by audio tags
    mime_type: string; //Optional. MIME type of the file as defined by sender
    file_size: integer; //Optional. File size

  end;


  TDocument = record
    // This object represents a general file (as opposed to Pphotos, Pvoice messages and Paudio files).

    file_id: string; //Unique file identifier
    thumb: PPhotoSize; //Optional. Document thumbnail as defined by sender
    file_name: string; //Optional. Original filename as defined by sender
    mime_type: string; //Optional. MIME type of the file as defined by sender
    file_size: integer; //Optional. File size

  end;


  TSticker = record // This object represents a sticker.

    file_id: string; //Unique identifier for this file
    Width: integer; //Sticker width
    Height: integer; //Sticker height
    thumb: PPhotoSize; //Optional. Sticker thumbnail in .webp or .jpg format
    emoji: string; //Optional. Emoji associated with the sticker
    file_size: integer; //Optional. File size

  end;


  TVideo = record // This object represents a video file.

    file_id: string; //Unique identifier for this file
    Width: integer; //Video width as defined by sender
    Height: integer; //Video height as defined by sender
    duration: integer; //Duration of the video in seconds as defined by sender
    thumb: PPhotoSize; //Optional. Video thumbnail
    mime_type: string; //Optional. Mime type of a file as defined by sender
    file_size: integer; //Optional. File size

  end;


  TVoice = record // This object represents a voice note.

    file_id: string; //Unique identifier for this file
    duration: integer; //Duration of the audio in seconds as defined by sender
    mime_type: string; //Optional. MIME type of the file as defined by sender
    file_size: integer; //Optional. File size

  end;


  TContact = record // This object represents a phone contact.

    phone_number: string; //Contact's phone number
    first_name: string; //Contact's first name
    last_name: string; //Optional. Contact's last name
    user_id: integer; //Optional. Contact's user identifier in Telegram

  end;


  TLocation = record // This object represents a point on the map.

    longitude: real; //Longitude as defined by sender
    latitude: real; //Latitude as defined by sender

  end;


  TVenue = record // This object represents a venue.

    location: PLocation; //Venue location
    title: string; //Name of the venue
    address: string; //Address of the venue
    foursquare_id: string; //Optional. Foursquare identifier of the venue

  end;


  TUserProfilePhotos = record // This object represent a user's profile pictures.

    total_count: integer; //Total number of profile pictures the target user has
    photos: array of array of PPhotoSize;
    //Requested profile pictures (in up to 4 sizes each)

  end;


  TFile = record
    // This object represents a file ready to be downloaded. The file can be downloaded via the link https://api.telegram.org/file/bot<token>/<file_path>. It is guaranteed that the link will be valid for at least 1 hour. When the link expires, a new one can be requested by calling PgetFile.

    file_id: string; //Unique identifier for this file
    file_size: integer; //Optional. File size, if known
    file_path: string;
    //Optional. File path. Use https://api.telegram.org/file/bot<token>/<file_path> to get the file.

  end;


  TReplyKeyboardMarkup = record
    // This object represents a Pcustom keyboard with reply options (see PIntroduction to bots for details and examples).

    keyboard: array of array of PKeyboardButton;
    //Array of button rows, each represented by an Array of PKeyboardButton objects
    resize_keyboard: boolean;
    //Optional. Requests clients to resize the keyboard vertically for optimal fit (e.g., make the keyboard smaller if there are just two rows of buttons). Defaults to false, in which case the custom keyboard is always of the same height as the app's standard keyboard.
    one_time_keyboard: boolean;
    //Optional. Requests clients to hide the keyboard as soon as it's been used. The keyboard will still be available, but clients will automatically display the usual letter-keyboard in the chat – the user can press a special button in the input field to see the custom keyboard again. Defaults to false.
    selective: boolean;
    //Optional. Use this parameter if you want to show the keyboard to specific users only. Targets: 1) users that are @mentioned in the text of the PMessage object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message.Example: A user requests to change the bot‘s language, bot replies to the request with a keyboard to select the new language. Other users in the group don’t see the keyboard.

  end;


  TKeyboardButton = record
    // This object represents one button of the reply keyboard. For simple text buttons String can be used instead of this object to specify text of the button. Optional fields are mutually exclusive.

    Text: string;
    //Text of the button. If none of the optional fields are used, it will be sent to the bot as a message when the button is pressed
    request_contact: boolean;
    //Optional. If Boolean, the user's phone number will be sent as a contact when the button is pressed. Available in private chats only
    request_location: boolean;
    //Optional. If Boolean, the user's current location will be sent when the button is pressed. Available in private chats only

  end;


  TReplyKeyboardHide = record
    // Upon receiving a message with this object, Telegram clients will hide the current custom keyboard and display the default letter-keyboard. By default, custom keyboards are displayed until a new keyboard is sent by a bot. An exception is made for one-time keyboards that are hidden immediately after the user presses a button (see PReplyKeyboardMarkup).

    hide_keyboard: boolean; //Requests clients to hide the custom keyboard
    selective: boolean;
    //Optional. Use this parameter if you want to hide keyboard for specific users only. Targets: 1) users that are @mentioned in the text of the PMessage object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message.Example: A user votes in a poll, bot returns confirmation message in reply to the vote and hides keyboard for that user, while still showing the keyboard with poll options to users who haven't voted yet.

  end;


  TInlineKeyboardMarkup = record
    // This object represents an Pinline keyboard that appears right next to the message it belongs to.

    inline_keyboard: array of array of PInlineKeyboardButton;
    //Array of button rows, each represented by an Array of PInlineKeyboardButton objects

  end;


  TInlineKeyboardButton = record
    // This object represents one button of an inline keyboard. You must use exactly one of the optional fields.

    Text: string; //Label text on the button
    url: string; //Optional. HTTP url to be opened when button is pressed
    callback_data: string;
    //Optional. Data to be sent in a Pcallback query to the bot when button is pressed, 1-64 bytes
    switch_inline_query: string;
    //Optional. If set, pressing the button will prompt the user to select one of their chats, open that chat and insert the bot‘s username and the specified inline query in the input field. Can be empty, in which case just the bot’s username will be inserted.Note: This offers an easy way for users to start using your bot in Pinline mode when they are currently in a private chat with it. Especially useful when combined with Pswitch_pm… actions – in this case the user will be automatically returned to the chat they switched from, skipping the chat selection screen.

  end;


  TCallbackQuery = record
    // This object represents an incoming callback query from a callback button in an Pinline keyboard. If the button that originated the query was attached to a message sent by the bot, the field message will be presented. If the button was attached to a message sent via the bot (in Pinline mode), the field inline_message_id will be presented.

    id: string; //Unique identifier for this query
    from: PUser; //Sender
    message: PMessage;
    //Optional. Message with the callback button that originated the query. Note that message content and message date will not be available if the message is too old
    inline_message_id: string;
    //Optional. Identifier of the message sent via the bot in inline mode, that originated the query
    Data: string;
    //Data associated with the callback button. Be aware that a bad client can send arbitrary data in this field

  end;


  TForceReply = record
    // Upon receiving a message with this object, Telegram clients will display a reply interface to the user (act as if the user has selected the bot‘s message and tapped ’Reply'). This can be extremely useful if you want to create user-friendly step-by-step interfaces without having to sacrifice Pprivacy mode.

    force_reply: boolean;
    //Shows reply interface to the user, as if they manually selected the bot‘s message and tapped ’Reply'
    selective: boolean;
    //Optional. Use this parameter if you want to force reply from specific users only. Targets: 1) users that are @mentioned in the text of the PMessage object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message.

  end;


  TInlineQuery = record
    // This object represents an incoming inline query. When the user sends an empty query, your bot could return some default or trending results.

    id: string; //Unique identifier for this query
    from: PUser; //Sender
    location: PLocation;
    //Optional. Sender location, only for bots that request user location
    query: string; //Text of the query (up to 512 characters)
    offset: string; //Offset of the results to be returned, can be controlled by the bot

  end;


  TInlineQueryResult = record
    // This object represents one result of an inline query. Telegram clients currently support results of the following 19 types:

    _type: string; //Type of the result, must be article
    id: string; //Unique identifier for this result, 1-64 Bytes
    title: string; //Title of the result
    input_message_content: PInputMessageContent; //Content of the message to be sent
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    url: string; //Optional. URL of the result
    hide_url: boolean;
    //Optional. Pass Boolean, if you don't want the URL to be shown in the message
    description: string; //Optional. Short description of the result
    thumb_url: string; //Optional. Url of the thumbnail for the result
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultArticle = record // Represents a link to an article or web page.

    _type: string; //Type of the result, must be article
    id: string; //Unique identifier for this result, 1-64 Bytes
    title: string; //Title of the result
    input_message_content: PInputMessageContent; //Content of the message to be sent
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    url: string; //Optional. URL of the result
    hide_url: boolean;
    //Optional. Pass Boolean, if you don't want the URL to be shown in the message
    description: string; //Optional. Short description of the result
    thumb_url: string; //Optional. Url of the thumbnail for the result
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultPhoto = record
    // Represents a link to a photo. By default, this photo will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the photo.

    _type: string; //Type of the result, must be photo
    id: string; //Unique identifier for this result, 1-64 bytes
    photo_url: string;
    //A valid URL of the photo. Photo must be in jpeg format. Photo size must not exceed 5MB
    thumb_url: string; //URL of the thumbnail for the photo
    photo_width: integer; //Optional. Width of the photo
    photo_height: integer; //Optional. Height of the photo
    title: string; //Optional. Title for the result
    description: string; //Optional. Short description of the result
    Caption: string; //Optional. Caption of the photo to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the photo

  end;


  TInlineQueryResultGif = record
    // Represents a link to an animated GIF file. By default, this animated GIF file will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.

    _type: string; //Type of the result, must be gif
    id: string; //Unique identifier for this result, 1-64 bytes
    gif_url: string; //A valid URL for the GIF file. File size must not exceed 1MB
    gif_width: integer; //Optional. Width of the GIF
    gif_height: integer; //Optional. Height of the GIF
    thumb_url: string; //URL of the static thumbnail for the result (jpeg or gif)
    title: string; //Optional. Title for the result
    Caption: string; //Optional. Caption of the GIF file to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PinputMessageContent;
    //Optional. Content of the message to be sent instead of the GIF animation

  end;


  TInlineQueryResultMpeg4Gif = record
    // Represents a link to a video animation (H.264/MPEG-4 AVC video without sound). By default, this animated MPEG-4 file will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.

    _type: string; //Type of the result, must be mpeg4_gif
    id: string; //Unique identifier for this result, 1-64 bytes
    mpeg4_url: string; //A valid URL for the MP4 file. File size must not exceed 1MB
    mpeg4_width: integer; //Optional. Video width
    mpeg4_height: integer; //Optional. Video height
    thumb_url: string; //URL of the static thumbnail (jpeg or gif) for the result
    title: string; //Optional. Title for the result
    Caption: string; //Optional. Caption of the MPEG-4 file to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the video animation

  end;


  TInlineQueryResultVideo = record
    // Represents a link to a page containing an embedded video player or a video file. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.

    _type: string; //Type of the result, must be video
    id: string; //Unique identifier for this result, 1-64 bytes
    video_url: string; //A valid URL for the embedded video player or video file
    mime_type: string;
    //Mime type of the content of video url, “text/html” or “video/mp4”
    thumb_url: string; //URL of the thumbnail (jpeg only) for the video
    title: string; //Title for the result
    Caption: string; //Optional. Caption of the video to be sent, 0-200 characters
    video_width: integer; //Optional. Video width
    video_height: integer; //Optional. Video height
    video_duration: integer; //Optional. Video duration in seconds
    description: string; //Optional. Short description of the result
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the video

  end;


  TInlineQueryResultAudio = record
    // Represents a link to an mp3 audio file. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.

    _type: string; //Type of the result, must be audio
    id: string; //Unique identifier for this result, 1-64 bytes
    audio_url: string; //A valid URL for the audio file
    title: string; //Title
    performer: string; //Optional. Performer
    audio_duration: integer; //Optional. Audio duration in seconds
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the audio

  end;


  TInlineQueryResultVoice = record
    // Represents a link to a voice recording in an .ogg container encoded with OPUS. By default, this voice recording will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the the voice message.

    _type: string; //Type of the result, must be voice
    id: string; //Unique identifier for this result, 1-64 bytes
    voice_url: string; //A valid URL for the voice recording
    title: string; //Recording title
    voice_duration: integer; //Optional. Recording duration in seconds
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the voice recording

  end;


  TInlineQueryResultDocument = record
    // Represents a link to a file. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file. Currently, only .PDF and .ZIP files can be sent using this method.

    _type: string; //Type of the result, must be document
    id: string; //Unique identifier for this result, 1-64 bytes
    title: string; //Title for the result
    Caption: string; //Optional. Caption of the document to be sent, 0-200 characters
    document_url: string; //A valid URL for the file
    mime_type: string;
    //Mime type of the content of the file, either “application/pdf” or “application/zip”
    description: string; //Optional. Short description of the result
    reply_markup: PInlineKeyboardMarkup;
    //Optional. Inline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the file
    thumb_url: string; //Optional. URL of the thumbnail (jpeg only) for the file
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultLocation = record
    // Represents a location on a map. By default, the location will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the location.

    _type: string; //Type of the result, must be location
    id: string; //Unique identifier for this result, 1-64 Bytes
    latitude: real; //Location latitude in degrees
    longitude: real; //Location longitude in degrees
    title: string; //Location title
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the location
    thumb_url: string; //Optional. Url of the thumbnail for the result
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultVenue = record
    // Represents a venue. By default, the venue will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the venue.

    _type: string; //Type of the result, must be venue
    id: string; //Unique identifier for this result, 1-64 Bytes
    latitude: real; //Latitude of the venue location in degrees
    longitude: real; //Longitude of the venue location in degrees
    title: string; //Title of the venue
    address: string; //Address of the venue
    foursquare_id: string; //Optional. Foursquare identifier of the venue if known
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the venue
    thumb_url: string; //Optional. Url of the thumbnail for the result
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultContact = record
    // Represents a contact with a phone number. By default, this contact will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the contact.

    _type: string; //Type of the result, must be contact
    id: string; //Unique identifier for this result, 1-64 Bytes
    phone_number: string; //Contact's phone number
    first_name: string; //Contact's first name
    last_name: string; //Optional. Contact's last name
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the contact
    thumb_url: string; //Optional. Url of the thumbnail for the result
    thumb_width: integer; //Optional. Thumbnail width
    thumb_height: integer; //Optional. Thumbnail height

  end;


  TInlineQueryResultCachedPhoto =
    record // Represents a link to a photo stored on the Telegram servers. By default, this photo will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the photo.

    _type: string; //Type of the result, must be photo
    id: string; //Unique identifier for this result, 1-64 bytes
    photo_file_id: string; //A valid file identifier of the photo
    title: string; //Optional. Title for the result
    description: string; //Optional. Short description of the result
    Caption: string; //Optional. Caption of the photo to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the photo

  end;


  TInlineQueryResultCachedGif = record
    // Represents a link to an animated GIF file stored on the Telegram servers. By default, this animated GIF file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with specified content instead of the animation.

    _type: string; //Type of the result, must be gif
    id: string; //Unique identifier for this result, 1-64 bytes
    gif_file_id: string; //A valid file identifier for the GIF file
    title: string; //Optional. Title for the result
    Caption: string; //Optional. Caption of the GIF file to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the GIF animation

  end;


  TInlineQueryResultCachedMpeg4Gif =
    record // Represents a link to a video animation (H.264/MPEG-4 AVC video without sound) stored on the Telegram servers. By default, this animated MPEG-4 file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.

    _type: string; //Type of the result, must be mpeg4_gif
    id: string; //Unique identifier for this result, 1-64 bytes
    mpeg4_file_id: string; //A valid file identifier for the MP4 file
    title: string; //Optional. Title for the result
    Caption: string; //Optional. Caption of the MPEG-4 file to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the video animation

  end;


  TInlineQueryResultCachedSticker =
    record // Represents a link to a sticker stored on the Telegram servers. By default, this sticker will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the sticker.

    _type: string; //Type of the result, must be sticker
    id: string; //Unique identifier for this result, 1-64 bytes
    sticker_file_id: string; //A valid file identifier of the sticker
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the sticker

  end;


  TInlineQueryResultCachedDocument =
    record // Represents a link to a file stored on the Telegram servers. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file. Currently, only pdf-files and zip archives can be sent using this method.

    _type: string; //Type of the result, must be document
    id: string; //Unique identifier for this result, 1-64 bytes
    title: string; //Title for the result
    document_file_id: string; //A valid file identifier for the file
    description: string; //Optional. Short description of the result
    Caption: string; //Optional. Caption of the document to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the file

  end;


  TInlineQueryResultCachedVideo =
    record // Represents a link to a video file stored on the Telegram servers. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.

    _type: string; //Type of the result, must be video
    id: string; //Unique identifier for this result, 1-64 bytes
    video_file_id: string; //A valid file identifier for the video file
    title: string; //Title for the result
    description: string; //Optional. Short description of the result
    Caption: string; //Optional. Caption of the video to be sent, 0-200 characters
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the video

  end;


  TInlineQueryResultCachedVoice =
    record // Represents a link to a voice message stored on the Telegram servers. By default, this voice message will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the voice message.

    _type: string; //Type of the result, must be voice
    id: string; //Unique identifier for this result, 1-64 bytes
    voice_file_id: string; //A valid file identifier for the voice message
    title: string; //Voice message title
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the voice message

  end;


  TInlineQueryResultCachedAudio =
    record // Represents a link to an mp3 audio file stored on the Telegram servers. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.

    _type: string; //Type of the result, must be audio
    id: string; //Unique identifier for this result, 1-64 bytes
    audio_file_id: string; //A valid file identifier for the audio file
    reply_markup: PInlineKeyboardMarkup;
    //Optional. An PInline keyboard attached to the message
    input_message_content: PInputMessageContent;
    //Optional. Content of the message to be sent instead of the audio

  end;


  TInputMessageContent = record
    // This object represents the content of a message to be sent as a result of an inline query. Telegram clients currently support the following 4 types:

    message_text: string; //Text of the message to be sent, 1-4096 characters
    parse_mode: string;
    //Optional. Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
    disable_web_page_preview: boolean;
    //Optional. Disables link previews for links in the sent message

  end;


  TInputTextMessageContent = record
    // Represents the Pcontent of a text message to be sent as the result of an inline query.

    message_text: string; //Text of the message to be sent, 1-4096 characters
    parse_mode: string;
    //Optional. Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
    disable_web_page_preview: boolean;
    //Optional. Disables link previews for links in the sent message

  end;


  TInputLocationMessageContent =
    record // Represents the Pcontent of a location message to be sent as the result of an inline query.

    latitude: real; //Latitude of the location in degrees
    longitude: real; //Longitude of the location in degrees

  end;


  TInputVenueMessageContent = record
    // Represents the Pcontent of a venue message to be sent as the result of an inline query.

    latitude: real; //Latitude of the venue in degrees
    longitude: real; //Longitude of the venue in degrees
    title: string; //Name of the venue
    address: string; //Address of the venue
    foursquare_id: string; //Optional. Foursquare identifier of the venue, if known

  end;


  TInputContactMessageContent = record
    // Represents the Pcontent of a contact message to be sent as the result of an inline query.

    phone_number: string; //Contact's phone number
    first_name: string; //Contact's first name
    last_name: string; //Optional. Contact's last name

  end;


  TChosenInlineResult = record
    // Represents a Presult of an inline query that was chosen by the user and sent to their chat partner.

    result_id: string; //The unique identifier for the result that was chosen
    from: PUser; //The user that chose the result
    location: PLocation;
    //Optional. Sender location, only for bots that require user location
    inline_message_id: string;
    //Optional. Identifier of the sent inline message. Available only if there is an Pinline keyboard attached to the message. Will be also received in Pcallback queries and can be used to Pedit the message.
    query: string; //The query that was used to obtain the result

  end;


  PUpdateArray = array of PUpdate;



function Request(const url, method: string; params: string = ''): string;

function JsonStringToJsonData(const AJSONString: string): TJSONObject;

function GetJsonValue(AJSONData: TJSONObject; AName: string): TJSONData;

function getMe(ABaseUrl: string): PUser;

procedure FillUpdateArray(AJsonArray: TJSONArray; var AResult: PUpdateArray);

procedure FillUpdate(ADataObject: TJSONObject; var ARec: PUpdate);

function ToJSONUpdate(ARec: PUpdate): TJSONData;

function getUpdates(ABaseUrl: string; // Base Url To Telegram Bot
  offset: integer;
  //Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned. An update is considered confirmed as soon as PgetUpdates is called with an offset higher than its update_id. The negative offset can be specified to retrieve updates starting from -offset update from the end of the updates queue. All previous updates will forgotten.
  limit: integer;
  //Limits the number of updates to be retrieved. Values between 1—100 are accepted. Defaults to 100.
  timeout: integer
  //Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling
  ): PUpdateArray; overload;

procedure FillUser(ADataObject: TJSONObject; var ARec: PUser);

function ToJSONUser(ARec: PUser): TJSONData;

procedure FillChat(ADataObject: TJSONObject; var ARec: PChat);

function ToJSONChat(ARec: PChat): TJSONData;

procedure FillMessage(ADataObject: TJSONObject; var ARec: PMessage);

function ToJSONMessage(ARec: PMessage): TJSONData;

procedure FillMessageEntity(ADataObject: TJSONObject; var ARec: PMessageEntity);

function ToJSONMessageEntity(ARec: PMessageEntity): TJSONData;

procedure FillPhotoSize(ADataObject: TJSONObject; var ARec: PPhotoSize);

function ToJSONPhotoSize(ARec: PPhotoSize): TJSONData;

procedure FillAudio(ADataObject: TJSONObject; var ARec: PAudio);

function ToJSONAudio(ARec: PAudio): TJSONData;

procedure FillDocument(ADataObject: TJSONObject; var ARec: PDocument);

function ToJSONDocument(ARec: PDocument): TJSONData;

procedure FillSticker(ADataObject: TJSONObject; var ARec: PSticker);

function ToJSONSticker(ARec: PSticker): TJSONData;

procedure FillVideo(ADataObject: TJSONObject; var ARec: PVideo);

function ToJSONVideo(ARec: PVideo): TJSONData;

procedure FillVoice(ADataObject: TJSONObject; var ARec: PVoice);

function ToJSONVoice(ARec: PVoice): TJSONData;

procedure FillContact(ADataObject: TJSONObject; var ARec: PContact);

function ToJSONContact(ARec: PContact): TJSONData;

procedure FillLocation(ADataObject: TJSONObject; var ARec: PLocation);

function ToJSONLocation(ARec: PLocation): TJSONData;

procedure FillVenue(ADataObject: TJSONObject; var ARec: PVenue);

function ToJSONVenue(ARec: PVenue): TJSONData;

procedure FillUserProfilePhotos(ADataObject: TJSONObject; var ARec: PUserProfilePhotos);

function ToJSONUserProfilePhotos(ARec: PUserProfilePhotos): TJSONData;

procedure FillFile(ADataObject: TJSONObject; var ARec: PFile);

function ToJSONFile(ARec: PFile): TJSONData;

procedure FillReplyKeyboardMarkup(ADataObject: TJSONObject;
  var ARec: PReplyKeyboardMarkup);

function ToJSONReplyKeyboardMarkup(ARec: PReplyKeyboardMarkup): TJSONData;

procedure FillKeyboardButton(ADataObject: TJSONObject; var ARec: PKeyboardButton);

function ToJSONKeyboardButton(ARec: PKeyboardButton): TJSONData;

procedure FillReplyKeyboardHide(ADataObject: TJSONObject; var ARec: PReplyKeyboardHide);

function ToJSONReplyKeyboardHide(ARec: PReplyKeyboardHide): TJSONData;

procedure FillInlineKeyboardMarkup(ADataObject: TJSONObject;
  var ARec: PInlineKeyboardMarkup);

function ToJSONInlineKeyboardMarkup(ARec: PInlineKeyboardMarkup): TJSONData;

procedure FillInlineKeyboardButton(ADataObject: TJSONObject;
  var ARec: PInlineKeyboardButton);

function ToJSONInlineKeyboardButton(ARec: PInlineKeyboardButton): TJSONData;

procedure FillCallbackQuery(ADataObject: TJSONObject; var ARec: PCallbackQuery);

function ToJSONCallbackQuery(ARec: PCallbackQuery): TJSONData;

procedure FillForceReply(ADataObject: TJSONObject; var ARec: PForceReply);

function ToJSONForceReply(ARec: PForceReply): TJSONData;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: integer;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage; overload;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: string;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage; overload;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: integer;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage; overload;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: string;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage; overload;

function sendChatAction(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  action: string
  //Type of action to broadcast. Choose one, depending on what the user is about to receive: typing for Ptext messages, upload_photo for Pphotos, record_video or upload_video for Pvideos, record_audio or upload_audio for Paudio files, upload_document for Pgeneral files, find_location for Plocation data.
  ): boolean; overload;

function sendChatAction(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  action: string
  //Type of action to broadcast. Choose one, depending on what the user is about to receive: typing for Ptext messages, upload_photo for Pphotos, record_video or upload_video for Pvideos, record_audio or upload_audio for Paudio files, upload_document for Pgeneral files, find_location for Plocation data.
  ): boolean; overload;

function getUserProfilePhotos(ABaseUrl: string; // Base Url To Telegram Bot
  user_id: integer; //Unique identifier of the target user
  offset: integer;
  //Sequential number of the first photo to be returned. By default, all photos are returned.
  limit: integer
  //Limits the number of photos to be retrieved. Values between 1—100 are accepted. Defaults to 100.
  ): PUserProfilePhotos; overload;

function getFile(ABaseUrl: string; // Base Url To Telegram Bot
  file_id: string //File identifier to get info about
  ): PFile; overload;

function kickChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean; overload;

function kickChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean; overload;

function unbanChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean; overload;

function unbanChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean; overload;

function answerCallbackQuery(ABaseUrl: string; // Base Url To Telegram Bot
  callback_query_id: string; //Unique identifier for the query to be answered
  Text: string;
  //Text of the notification. If not specified, nothing will be shown to the user
  show_alert: boolean
  //If true, an alert will be shown by the client instead of a notification at the top of the chat screen. Defaults to false.
  ): boolean; overload;

function editMessageText(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Text: string; //New text of the message
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

function editMessageText(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Text: string; //New text of the message
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

function editMessageCaption(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Caption: string; //New caption of the message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

function editMessageCaption(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Caption: string; //New caption of the message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

function editMessageReplyMarkup(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

function editMessageReplyMarkup(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage; overload;

procedure FillInlineQuery(ADataObject: TJSONObject; var ARec: PInlineQuery);

function ToJSONInlineQuery(ARec: PInlineQuery): TJSONData;

function answerInlineQuery(ABaseUrl: string; // Base Url To Telegram Bot
  inline_query_id: string; //Unique identifier for the answered query
  results: array of PInlineQueryResult;
  //A JSON-serialized array of results for the inline query
  cache_time: integer;
  //The maximum amount of time in seconds that the result of the inline query may be cached on the server. Defaults to 300.
  is_personal: boolean;
  //Pass Boolean, if results may be cached on the server side only for the user that sent the query. By default, results may be returned to any user who sends the same query
  next_offset: string;
  //Pass the offset that a client should send in the next query with the same text to receive more results. Pass an empty string if there are no more results or if you don‘t support pagination. Offset length can’t exceed 64 bytes.
  switch_pm_text: string;
  //If passed, clients will display a button with specified text that switches the user to a private chat with the bot and sends the bot a start message with the parameter switch_pm_parameter
  switch_pm_parameter: string
  //Parameter for the start message sent to the bot when user presses the switch buttonExample: An inline bot that sends YouTube videos can ask the user to connect the bot to their YouTube account to adapt search results accordingly. To do this, it displays a ‘Connect your YouTube account’ button above the results, or even before showing any. The user presses the button, switches to a private chat with the bot and, in doing so, passes a start parameter that instructs the bot to return an oauth link. Once done, the bot can offer a Pswitch_inline button so that the user can easily return to the chat where they wanted to use the bot's inline capabilities.
  ): boolean; overload;

procedure FillInlineQueryResult(ADataObject: TJSONObject; var ARec: PInlineQueryResult);

function ToJSONInlineQueryResult(ARec: PInlineQueryResult): TJSONData;

procedure FillInlineQueryResultArticle(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultArticle);

function ToJSONInlineQueryResultArticle(ARec: PInlineQueryResultArticle): TJSONData;

procedure FillInlineQueryResultPhoto(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultPhoto);

function ToJSONInlineQueryResultPhoto(ARec: PInlineQueryResultPhoto): TJSONData;

procedure FillInlineQueryResultGif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultGif);

function ToJSONInlineQueryResultGif(ARec: PInlineQueryResultGif): TJSONData;

procedure FillInlineQueryResultMpeg4Gif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultMpeg4Gif);

function ToJSONInlineQueryResultMpeg4Gif(ARec: PInlineQueryResultMpeg4Gif): TJSONData;

procedure FillInlineQueryResultVideo(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVideo);

function ToJSONInlineQueryResultVideo(ARec: PInlineQueryResultVideo): TJSONData;

procedure FillInlineQueryResultAudio(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultAudio);

function ToJSONInlineQueryResultAudio(ARec: PInlineQueryResultAudio): TJSONData;

procedure FillInlineQueryResultVoice(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVoice);

function ToJSONInlineQueryResultVoice(ARec: PInlineQueryResultVoice): TJSONData;

procedure FillInlineQueryResultDocument(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultDocument);

function ToJSONInlineQueryResultDocument(ARec: PInlineQueryResultDocument): TJSONData;

procedure FillInlineQueryResultLocation(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultLocation);

function ToJSONInlineQueryResultLocation(ARec: PInlineQueryResultLocation): TJSONData;

procedure FillInlineQueryResultVenue(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVenue);

function ToJSONInlineQueryResultVenue(ARec: PInlineQueryResultVenue): TJSONData;

procedure FillInlineQueryResultContact(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultContact);

function ToJSONInlineQueryResultContact(ARec: PInlineQueryResultContact): TJSONData;

procedure FillInlineQueryResultCachedPhoto(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedPhoto);

function ToJSONInlineQueryResultCachedPhoto(
  ARec: PInlineQueryResultCachedPhoto): TJSONData;

procedure FillInlineQueryResultCachedGif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedGif);

function ToJSONInlineQueryResultCachedGif(ARec: PInlineQueryResultCachedGif): TJSONData;

procedure FillInlineQueryResultCachedMpeg4Gif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedMpeg4Gif);

function ToJSONInlineQueryResultCachedMpeg4Gif(
  ARec: PInlineQueryResultCachedMpeg4Gif): TJSONData;

procedure FillInlineQueryResultCachedSticker(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedSticker);

function ToJSONInlineQueryResultCachedSticker(
  ARec: PInlineQueryResultCachedSticker): TJSONData;

procedure FillInlineQueryResultCachedDocument(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedDocument);

function ToJSONInlineQueryResultCachedDocument(
  ARec: PInlineQueryResultCachedDocument): TJSONData;

procedure FillInlineQueryResultCachedVideo(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedVideo);

function ToJSONInlineQueryResultCachedVideo(
  ARec: PInlineQueryResultCachedVideo): TJSONData;

procedure FillInlineQueryResultCachedVoice(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedVoice);

function ToJSONInlineQueryResultCachedVoice(
  ARec: PInlineQueryResultCachedVoice): TJSONData;

procedure FillInlineQueryResultCachedAudio(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedAudio);

function ToJSONInlineQueryResultCachedAudio(
  ARec: PInlineQueryResultCachedAudio): TJSONData;

procedure FillInputMessageContent(ADataObject: TJSONObject;
  var ARec: PInputMessageContent);

function ToJSONInputMessageContent(ARec: PInputMessageContent): TJSONData;

procedure FillInputTextMessageContent(ADataObject: TJSONObject;
  var ARec: PInputTextMessageContent);

function ToJSONInputTextMessageContent(ARec: PInputTextMessageContent): TJSONData;

procedure FillInputLocationMessageContent(ADataObject: TJSONObject;
  var ARec: PInputLocationMessageContent);

function ToJSONInputLocationMessageContent(ARec: PInputLocationMessageContent):
  TJSONData;

procedure FillInputVenueMessageContent(ADataObject: TJSONObject;
  var ARec: PInputVenueMessageContent);

function ToJSONInputVenueMessageContent(ARec: PInputVenueMessageContent): TJSONData;

procedure FillInputContactMessageContent(ADataObject: TJSONObject;
  var ARec: PInputContactMessageContent);

function ToJSONInputContactMessageContent(ARec: PInputContactMessageContent): TJSONData;

procedure FillChosenInlineResult(ADataObject: TJSONObject;
  var ARec: PChosenInlineResult);

function ToJSONChosenInlineResult(ARec: PChosenInlineResult): TJSONData;

implementation

function Request(const url, method: string; params: string): string;
const
  CRLF = #13#10;
var
  Lines: TStringList;
  Client: THTTPSend;
  IsOK: boolean;
  Bound: string;
  I: integer;
  AStr: string;
  AStream: TFileStream;
  AFileName: string;
begin
  Lines := TStringList.Create;
  Client := THTTPSend.Create;
  Result := 'Failed to connect.';
  Bound := IntToHex(Random(MaxInt), 8) + '_MohsenTiBotApi_boundary';
  if AnsiStartsText('https', url) then
  begin
    //WriteLn('Sending HTTPS ' + method + ' request to ' + url);
    try
      Client.Sock.CreateWithSSL(TSSLOpenSSL);
      if params <> '' then
      begin
        //if (AStream = nil) then
        //begin
        //  WriteStrToStream(Client.Document, params);
        //  Client.MimeType := 'application/x-www-form-urlencoded';
        //end
        //else
        begin
          Lines.Delimiter := '&';
          Lines.StrictDelimiter := True;
          Lines.DelimitedText := params;
          WriteLn(Lines.Count);
          for I := 0 to Lines.Count - 1 do
          begin
            if (I = 0) then
            begin
              AStr := '';
            end
            else
            begin
              AStr := CRLF;
            end;
            if (Lines.Strings[I] = '') then Continue;
            if (AnsiStartsStr('file://', Lines.ValueFromIndex[I])) then
            begin
              AFileName := Copy(Lines.ValueFromIndex[I], 8,
                Length(Lines.ValueFromIndex[I]) - 7);

              WriteStrToStream(Client.Document,
                CRLF + '--' + Bound + CRLF + 'Content-Disposition: form-data; name=' +
                AnsiQuotedStr(Lines.Names[I], '"') + ';' + CRLF +
                #9'filename=' + AnsiQuotedStr(AFileName, '"') + CRLF +
                'Content-Type: application/octet-string' + CRLF + CRLF);
              AStream := TFileStream.Create(AFileName, fmOpenRead);
              Client.Document.CopyFrom(AStream, 0);
              AStream.Free;
            end
            else
            begin
              WriteStrToStream(Client.Document, AStr + '--' +
                Bound + CRLF + 'Content-Disposition: form-data; name=' +
                AnsiQuotedStr(Lines.Names[I], '"') + CRLF +
                'Content-Type: text/plain' + CRLF + CRLF);
              WriteStrToStream(Client.Document, Lines.ValueFromIndex[I]);
            end;
          end;
          WriteStrToStream(Client.Document,
            CRLF + '--' + Bound + '--' + CRLF);

          Client.MimeType := 'multipart/form-data; boundary=' + Bound;
        end;
      end;
      Lines.Free;

      Client.Timeout := 1000;
      Lines := TStringList.Create;
      IsOK := Client.HTTPMethod(method, url);
      if IsOK then
        Lines.LoadFromStream(Client.Document)
      else
        WriteLn(Client.ResultCode, ' ', Client.ResultString);
    finally
      Client.Free;
    end;
  end
  else if AnsiStartsText('http', url) then
  begin
    //WriteLn('Sending HTTP ' + method + ' request to ' + url);
    try
      if params <> '' then
      begin
        WriteStrToStream(Client.Document, params);
        Client.MimeType := 'application/x-www-form-urlencoded';
      end;
      IsOK := Client.HTTPMethod(method, url);
      if IsOK then
        Lines.LoadFromStream(Client.Document);
    finally
      Client.Free;
    end;
  end
  else
    Result := 'Missing or Unsupported protocol.';
  Result := Lines.Text;
  Lines.Free;
end;

function JsonStringToJsonData(const AJSONString: string): TJSONObject;
var
  AParser: TJSONParser;
begin
  AParser := TJSONParser.Create(AJSONString);
  Result := AParser.Parse as TJSONObject;
  AParser.Free;
end;

function GetJsonValue(AJSONData: TJSONObject; AName: string): TJSONData;
begin
  Result := AJSONData.Find(AName);
end;

function getMe(ABaseUrl: string): PUser;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'getMe';
  GetQuery := '';
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillUser(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

procedure FillUpdateArray(AJsonArray: TJSONArray; var AResult: PUpdateArray);
var
  I: integer;
begin
  SetLength(AResult, AJsonArray.Count);
  for I := 0 to AJsonArray.Count - 1 do
  begin
    New(AResult[I]);
    FillUpdate(AJsonArray[I] as TJSONObject, AResult[I]);
  end;
end;

procedure FillUpdate(ADataObject: TJSONObject; var ARec: PUpdate);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'update_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.update_id := -1
  else
    ARec^.update_id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'message');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.message := nil
  else
  begin
    New(ARec^.message);
    FillMessage(TJSONObject(AResData), ARec^.message);
  end;
  AResData := GetJsonValue(ADataObject, 'inline_query');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.inline_query := nil
  else
  begin
    New(ARec^.inline_query);
    FillInlineQuery(TJSONObject(AResData), ARec^.inline_query);
  end;
  AResData := GetJsonValue(ADataObject, 'chosen_inline_result');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.chosen_inline_result := nil
  else
  begin
    New(ARec^.chosen_inline_result);
    FillChosenInlineResult(TJSONObject(AResData), ARec^.chosen_inline_result);
  end;
  AResData := GetJsonValue(ADataObject, 'callback_query');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.callback_query := nil
  else
  begin
    New(ARec^.callback_query);
    FillCallbackQuery(TJSONObject(AResData), ARec^.callback_query);
  end;

end;


function ToJSONUpdate(ARec: PUpdate): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('update_id', ARec^.update_id);
  if (ARec^.message <> nil) then
    AResData.Add('message', ToJSONMessage(ARec^.message));
  if (ARec^.inline_query <> nil) then
    AResData.Add('inline_query', ToJSONInlineQuery(ARec^.inline_query));
  if (ARec^.chosen_inline_result <> nil) then
    AResData.Add('chosen_inline_result', ToJSONChosenInlineResult(
      ARec^.chosen_inline_result));
  if (ARec^.callback_query <> nil) then
    AResData.Add('callback_query', ToJSONCallbackQuery(ARec^.callback_query));

  Result := AResData;
end;


function getUpdates(ABaseUrl: string; // Base Url To Telegram Bot
  offset: integer;
  //Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned. An update is considered confirmed as soon as PgetUpdates is called with an offset higher than its update_id. The negative offset can be specified to retrieve updates starting from -offset update from the end of the updates queue. All previous updates will forgotten.
  limit: integer;
  //Limits the number of updates to be retrieved. Values between 1—100 are accepted. Defaults to 100.
  timeout: integer
  //Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling
  ): PUpdateArray;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'getUpdates';
  GetQuery := '';
  GetQuery += 'offset=' + IntToStr(offset) + '&';
  GetQuery += 'limit=' + IntToStr(limit) + '&';
  GetQuery += 'timeout=' + IntToStr(timeout);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  //new(Result);
  FillUpdateArray(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONArray, Result);
end;

procedure FillUser(ADataObject: TJSONObject; var ARec: PUser);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := -1
  else
    ARec^.id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'first_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.first_name := ''
  else
    ARec^.first_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'last_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.last_name := ''
  else
    ARec^.last_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'username');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.username := ''
  else
    ARec^.username := AResData.AsString;

end;


function ToJSONUser(ARec: PUser): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('id', ARec^.id);
  AResData.Add('first_name', ARec^.first_name);
  AResData.Add('last_name', ARec^.last_name);
  AResData.Add('username', ARec^.username);

  Result := AResData;
end;


procedure FillChat(ADataObject: TJSONObject; var ARec: PChat);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := -1
  else
    ARec^.id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'username');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.username := ''
  else
    ARec^.username := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'first_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.first_name := ''
  else
    ARec^.first_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'last_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.last_name := ''
  else
    ARec^.last_name := AResData.AsString;

end;


function ToJSONChat(ARec: PChat): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('id', ARec^.id);
  AResData.Add('type', ARec^._type);
  AResData.Add('title', ARec^.title);
  AResData.Add('username', ARec^.username);
  AResData.Add('first_name', ARec^.first_name);
  AResData.Add('last_name', ARec^.last_name);

  Result := AResData;
end;


procedure FillMessage(ADataObject: TJSONObject; var ARec: PMessage);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'message_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.message_id := -1
  else
    ARec^.message_id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'from');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.from := nil
  else
  begin
    New(ARec^.from);
    FillUser(TJSONObject(AResData), ARec^.from);
  end;
  AResData := GetJsonValue(ADataObject, 'date');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.date := -1
  else
    ARec^.date := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'chat');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.chat := nil
  else
  begin
    New(ARec^.chat);
    FillChat(TJSONObject(AResData), ARec^.chat);
  end;
  AResData := GetJsonValue(ADataObject, 'forward_from');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.forward_from := nil
  else
  begin
    New(ARec^.forward_from);
    FillUser(TJSONObject(AResData), ARec^.forward_from);
  end;
  AResData := GetJsonValue(ADataObject, 'forward_from_chat');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.forward_from_chat := nil
  else
  begin
    New(ARec^.forward_from_chat);
    FillChat(TJSONObject(AResData), ARec^.forward_from_chat);
  end;
  AResData := GetJsonValue(ADataObject, 'forward_date');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.forward_date := -1
  else
    ARec^.forward_date := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'reply_to_message');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_to_message := nil
  else
  begin
    New(ARec^.reply_to_message);
    FillMessage(TJSONObject(AResData), ARec^.reply_to_message);
  end;
  AResData := GetJsonValue(ADataObject, 'text');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Text := ''
  else
    ARec^.Text := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'entities');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.entities, 0)
  else
  begin
    SetLength(ARec^.entities, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.entities) - 1 do
    begin
      New(ARec^.entities[I]);
      FillMessageEntity(TJSONArray(AResData).Objects[I], ARec^.entities[I]);
    end;
  end;
  AResData := GetJsonValue(ADataObject, 'audio');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.audio := nil
  else
  begin
    New(ARec^.audio);
    FillAudio(TJSONObject(AResData), ARec^.audio);
  end;
  AResData := GetJsonValue(ADataObject, 'document');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.document := nil
  else
  begin
    New(ARec^.document);
    FillDocument(TJSONObject(AResData), ARec^.document);
  end;
  AResData := GetJsonValue(ADataObject, 'photo');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.photo, 0)
  else
  begin
    SetLength(ARec^.photo, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.photo) - 1 do
    begin
      New(ARec^.photo[I]);
      FillPhotoSize(TJSONArray(AResData).Objects[I], ARec^.photo[I]);
    end;
  end;
  AResData := GetJsonValue(ADataObject, 'sticker');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.sticker := nil
  else
  begin
    New(ARec^.sticker);
    FillSticker(TJSONObject(AResData), ARec^.sticker);
  end;
  AResData := GetJsonValue(ADataObject, 'video');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video := nil
  else
  begin
    New(ARec^.video);
    FillVideo(TJSONObject(AResData), ARec^.video);
  end;
  AResData := GetJsonValue(ADataObject, 'voice');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.voice := nil
  else
  begin
    New(ARec^.voice);
    FillVoice(TJSONObject(AResData), ARec^.voice);
  end;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'contact');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.contact := nil
  else
  begin
    New(ARec^.contact);
    FillContact(TJSONObject(AResData), ARec^.contact);
  end;
  AResData := GetJsonValue(ADataObject, 'location');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.location := nil
  else
  begin
    New(ARec^.location);
    FillLocation(TJSONObject(AResData), ARec^.location);
  end;
  AResData := GetJsonValue(ADataObject, 'venue');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.venue := nil
  else
  begin
    New(ARec^.venue);
    FillVenue(TJSONObject(AResData), ARec^.venue);
  end;
  AResData := GetJsonValue(ADataObject, 'new_chat_member');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.new_chat_member := nil
  else
  begin
    New(ARec^.new_chat_member);
    FillUser(TJSONObject(AResData), ARec^.new_chat_member);
  end;
  AResData := GetJsonValue(ADataObject, 'left_chat_member');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.left_chat_member := nil
  else
  begin
    New(ARec^.left_chat_member);
    FillUser(TJSONObject(AResData), ARec^.left_chat_member);
  end;
  AResData := GetJsonValue(ADataObject, 'new_chat_title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.new_chat_title := ''
  else
    ARec^.new_chat_title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'new_chat_photo');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.new_chat_photo, 0)
  else
  begin
    SetLength(ARec^.new_chat_photo, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.new_chat_photo) - 1 do
    begin
      New(ARec^.new_chat_photo[I]);
      FillPhotoSize(TJSONArray(AResData).Objects[I], ARec^.new_chat_photo[I]);
    end;
  end;
  AResData := GetJsonValue(ADataObject, 'delete_chat_photo');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.delete_chat_photo := False
  else
    ARec^.delete_chat_photo := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'group_chat_created');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.group_chat_created := False
  else
    ARec^.group_chat_created := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'supergroup_chat_created');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.supergroup_chat_created := False
  else
    ARec^.supergroup_chat_created := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'channel_chat_created');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.channel_chat_created := False
  else
    ARec^.channel_chat_created := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'migrate_to_chat_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.migrate_to_chat_id := -1
  else
    ARec^.migrate_to_chat_id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'migrate_from_chat_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.migrate_from_chat_id := -1
  else
    ARec^.migrate_from_chat_id := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'pinned_message');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.pinned_message := nil
  else
  begin
    New(ARec^.pinned_message);
    FillMessage(TJSONObject(AResData), ARec^.pinned_message);
  end;

end;


function ToJSONMessage(ARec: PMessage): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('message_id', ARec^.message_id);
  if (ARec^.from <> nil) then
    AResData.Add('from', ToJSONUser(ARec^.from));
  AResData.Add('date', ARec^.date);
  if (ARec^.chat <> nil) then
    AResData.Add('chat', ToJSONChat(ARec^.chat));
  if (ARec^.forward_from <> nil) then
    AResData.Add('forward_from', ToJSONUser(ARec^.forward_from));
  if (ARec^.forward_from_chat <> nil) then
    AResData.Add('forward_from_chat', ToJSONChat(ARec^.forward_from_chat));
  AResData.Add('forward_date', ARec^.forward_date);
  if (ARec^.reply_to_message <> nil) then
    AResData.Add('reply_to_message', ToJSONMessage(ARec^.reply_to_message));
  AResData.Add('text', ARec^.Text);
  if ((ARec^.entities <> nil) and (Length(ARec^.entities) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.entities) - 1 do
    begin
      AResArray.Add(ToJSONMessageEntity(ARec^.entities[I]));
    end;
    AResData.Add('entities', AResArray);
  end;

  if (ARec^.audio <> nil) then
    AResData.Add('audio', ToJSONAudio(ARec^.audio));
  if (ARec^.document <> nil) then
    AResData.Add('document', ToJSONDocument(ARec^.document));
  if ((ARec^.photo <> nil) and (Length(ARec^.photo) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.photo) - 1 do
    begin
      AResArray.Add(ToJSONPhotoSize(ARec^.photo[I]));
    end;
    AResData.Add('photo', AResArray);
  end;

  if (ARec^.sticker <> nil) then
    AResData.Add('sticker', ToJSONSticker(ARec^.sticker));
  if (ARec^.video <> nil) then
    AResData.Add('video', ToJSONVideo(ARec^.video));
  if (ARec^.voice <> nil) then
    AResData.Add('voice', ToJSONVoice(ARec^.voice));
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.contact <> nil) then
    AResData.Add('contact', ToJSONContact(ARec^.contact));
  if (ARec^.location <> nil) then
    AResData.Add('location', ToJSONLocation(ARec^.location));
  if (ARec^.venue <> nil) then
    AResData.Add('venue', ToJSONVenue(ARec^.venue));
  if (ARec^.new_chat_member <> nil) then
    AResData.Add('new_chat_member', ToJSONUser(ARec^.new_chat_member));
  if (ARec^.left_chat_member <> nil) then
    AResData.Add('left_chat_member', ToJSONUser(ARec^.left_chat_member));
  AResData.Add('new_chat_title', ARec^.new_chat_title);
  if ((ARec^.new_chat_photo <> nil) and (Length(ARec^.new_chat_photo) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.new_chat_photo) - 1 do
    begin
      AResArray.Add(ToJSONPhotoSize(ARec^.new_chat_photo[I]));
    end;
    AResData.Add('new_chat_photo', AResArray);
  end;

  AResData.Add('delete_chat_photo', ARec^.delete_chat_photo);
  AResData.Add('group_chat_created', ARec^.group_chat_created);
  AResData.Add('supergroup_chat_created', ARec^.supergroup_chat_created);
  AResData.Add('channel_chat_created', ARec^.channel_chat_created);
  AResData.Add('migrate_to_chat_id', ARec^.migrate_to_chat_id);
  AResData.Add('migrate_from_chat_id', ARec^.migrate_from_chat_id);
  if (ARec^.pinned_message <> nil) then
    AResData.Add('pinned_message', ToJSONMessage(ARec^.pinned_message));

  Result := AResData;
end;


procedure FillMessageEntity(ADataObject: TJSONObject; var ARec: PMessageEntity);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'offset');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.offset := -1
  else
    ARec^.offset := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'length');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.length := -1
  else
    ARec^.length := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.url := ''
  else
    ARec^.url := AResData.AsString;

end;


function ToJSONMessageEntity(ARec: PMessageEntity): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('offset', ARec^.offset);
  AResData.Add('length', ARec^.length);
  AResData.Add('url', ARec^.url);

  Result := AResData;
end;


procedure FillPhotoSize(ADataObject: TJSONObject; var ARec: PPhotoSize);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Width := -1
  else
    ARec^.Width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Height := -1
  else
    ARec^.Height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONPhotoSize(ARec: PPhotoSize): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('width', ARec^.Width);
  AResData.Add('height', ARec^.Height);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillAudio(ADataObject: TJSONObject; var ARec: PAudio);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.duration := -1
  else
    ARec^.duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'performer');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.performer := ''
  else
    ARec^.performer := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONAudio(ARec: PAudio): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('duration', ARec^.duration);
  AResData.Add('performer', ARec^.performer);
  AResData.Add('title', ARec^.title);
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillDocument(ADataObject: TJSONObject; var ARec: PDocument);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb := nil
  else
  begin
    New(ARec^.thumb);
    FillPhotoSize(TJSONObject(AResData), ARec^.thumb);
  end;
  AResData := GetJsonValue(ADataObject, 'file_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_name := ''
  else
    ARec^.file_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONDocument(ARec: PDocument): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  if (ARec^.thumb <> nil) then
    AResData.Add('thumb', ToJSONPhotoSize(ARec^.thumb));
  AResData.Add('file_name', ARec^.file_name);
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillSticker(ADataObject: TJSONObject; var ARec: PSticker);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Width := -1
  else
    ARec^.Width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Height := -1
  else
    ARec^.Height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb := nil
  else
  begin
    New(ARec^.thumb);
    FillPhotoSize(TJSONObject(AResData), ARec^.thumb);
  end;
  AResData := GetJsonValue(ADataObject, 'emoji');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.emoji := ''
  else
    ARec^.emoji := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONSticker(ARec: PSticker): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('width', ARec^.Width);
  AResData.Add('height', ARec^.Height);
  if (ARec^.thumb <> nil) then
    AResData.Add('thumb', ToJSONPhotoSize(ARec^.thumb));
  AResData.Add('emoji', ARec^.emoji);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillVideo(ADataObject: TJSONObject; var ARec: PVideo);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Width := -1
  else
    ARec^.Width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Height := -1
  else
    ARec^.Height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.duration := -1
  else
    ARec^.duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb := nil
  else
  begin
    New(ARec^.thumb);
    FillPhotoSize(TJSONObject(AResData), ARec^.thumb);
  end;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONVideo(ARec: PVideo): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('width', ARec^.Width);
  AResData.Add('height', ARec^.Height);
  AResData.Add('duration', ARec^.duration);
  if (ARec^.thumb <> nil) then
    AResData.Add('thumb', ToJSONPhotoSize(ARec^.thumb));
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillVoice(ADataObject: TJSONObject; var ARec: PVoice);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.duration := -1
  else
    ARec^.duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;

end;


function ToJSONVoice(ARec: PVoice): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('duration', ARec^.duration);
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('file_size', ARec^.file_size);

  Result := AResData;
end;


procedure FillContact(ADataObject: TJSONObject; var ARec: PContact);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'phone_number');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.phone_number := ''
  else
    ARec^.phone_number := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'first_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.first_name := ''
  else
    ARec^.first_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'last_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.last_name := ''
  else
    ARec^.last_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'user_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.user_id := -1
  else
    ARec^.user_id := AResData.AsInteger;

end;


function ToJSONContact(ARec: PContact): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('phone_number', ARec^.phone_number);
  AResData.Add('first_name', ARec^.first_name);
  AResData.Add('last_name', ARec^.last_name);
  AResData.Add('user_id', ARec^.user_id);

  Result := AResData;
end;


procedure FillLocation(ADataObject: TJSONObject; var ARec: PLocation);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'longitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.longitude := -1
  else
    ARec^.longitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'latitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.latitude := -1
  else
    ARec^.latitude := AResData.AsFloat;

end;


function ToJSONLocation(ARec: PLocation): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('longitude', ARec^.longitude);
  AResData.Add('latitude', ARec^.latitude);

  Result := AResData;
end;


procedure FillVenue(ADataObject: TJSONObject; var ARec: PVenue);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'location');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.location := nil
  else
  begin
    New(ARec^.location);
    FillLocation(TJSONObject(AResData), ARec^.location);
  end;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'address');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.address := ''
  else
    ARec^.address := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'foursquare_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.foursquare_id := ''
  else
    ARec^.foursquare_id := AResData.AsString;

end;


function ToJSONVenue(ARec: PVenue): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  if (ARec^.location <> nil) then
    AResData.Add('location', ToJSONLocation(ARec^.location));
  AResData.Add('title', ARec^.title);
  AResData.Add('address', ARec^.address);
  AResData.Add('foursquare_id', ARec^.foursquare_id);

  Result := AResData;
end;


procedure FillUserProfilePhotos(ADataObject: TJSONObject; var ARec: PUserProfilePhotos);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'total_count');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.total_count := -1
  else
    ARec^.total_count := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'photos');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.photos, 0)
  else
  begin
    SetLength(ARec^.photos, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.photos) - 1 do
    begin
      if (TJSONArray(AResData).Arrays[I] = nil) or
        (TJSONArray(AResData).Arrays[I].IsNull) then
        SetLength(ARec^.photos[I], 0)
      else
      begin
        SetLength(ARec^.photos[I], TJSONArray(AResData).Arrays[I].Count);
        for J := 0 to Length(ARec^.photos[I]) - 1 do
        begin
          FillPhotoSize(TJSONArray(AResData).Arrays[I].Objects[J], ARec^.photos[I][J]);
        end;
      end;
    end;
  end;

end;


function ToJSONUserProfilePhotos(ARec: PUserProfilePhotos): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('total_count', ARec^.total_count);
  if ((ARec^.photos <> nil) and (Length(ARec^.photos) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.photos) - 1 do
    begin
      BResArray := TJSONArray.Create();
      for J := 0 to Length(ARec^.photos[I]) - 1 do
      begin
        BResArray.Add(ToJSONPhotoSize(ARec^.photos[I][J]));
      end;
      AResArray.Add(BResArray);
    end;
    AResData.Add('photos', AResArray);
  end;


  Result := AResData;
end;


procedure FillFile(ADataObject: TJSONObject; var ARec: PFile);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_id := ''
  else
    ARec^.file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'file_size');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_size := -1
  else
    ARec^.file_size := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'file_path');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.file_path := ''
  else
    ARec^.file_path := AResData.AsString;

end;


function ToJSONFile(ARec: PFile): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('file_id', ARec^.file_id);
  AResData.Add('file_size', ARec^.file_size);
  AResData.Add('file_path', ARec^.file_path);

  Result := AResData;
end;


procedure FillReplyKeyboardMarkup(ADataObject: TJSONObject;
  var ARec: PReplyKeyboardMarkup);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'keyboard');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.keyboard, 0)
  else
  begin
    SetLength(ARec^.keyboard, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.keyboard) - 1 do
    begin
      if (TJSONArray(AResData).Arrays[I] = nil) or
        (TJSONArray(AResData).Arrays[I].IsNull) then
        SetLength(ARec^.keyboard[I], 0)
      else
      begin
        SetLength(ARec^.keyboard[I], TJSONArray(AResData).Arrays[I].Count);
        for J := 0 to Length(ARec^.keyboard[I]) - 1 do
        begin
          FillKeyboardButton(TJSONArray(AResData).Arrays[I].Objects[J],
            ARec^.keyboard[I][J]);
        end;
      end;
    end;
  end;
  AResData := GetJsonValue(ADataObject, 'resize_keyboard');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.resize_keyboard := False
  else
    ARec^.resize_keyboard := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'one_time_keyboard');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.one_time_keyboard := False
  else
    ARec^.one_time_keyboard := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'selective');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.selective := False
  else
    ARec^.selective := AResData.AsBoolean;

end;


function ToJSONReplyKeyboardMarkup(ARec: PReplyKeyboardMarkup): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  if ((ARec^.keyboard <> nil) and (Length(ARec^.keyboard) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.keyboard) - 1 do
    begin
      BResArray := TJSONArray.Create();
      for J := 0 to Length(ARec^.keyboard[I]) - 1 do
      begin
        BResArray.Add(ToJSONKeyboardButton(ARec^.keyboard[I][J]));
      end;
      AResArray.Add(BResArray);
    end;
    AResData.Add('keyboard', AResArray);
  end;

  AResData.Add('resize_keyboard', ARec^.resize_keyboard);
  AResData.Add('one_time_keyboard', ARec^.one_time_keyboard);
  AResData.Add('selective', ARec^.selective);

  Result := AResData;
end;


procedure FillKeyboardButton(ADataObject: TJSONObject; var ARec: PKeyboardButton);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'text');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Text := ''
  else
    ARec^.Text := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'request_contact');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.request_contact := False
  else
    ARec^.request_contact := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'request_location');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.request_location := False
  else
    ARec^.request_location := AResData.AsBoolean;

end;


function ToJSONKeyboardButton(ARec: PKeyboardButton): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('text', ARec^.Text);
  AResData.Add('request_contact', ARec^.request_contact);
  AResData.Add('request_location', ARec^.request_location);

  Result := AResData;
end;


procedure FillReplyKeyboardHide(ADataObject: TJSONObject; var ARec: PReplyKeyboardHide);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'hide_keyboard');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.hide_keyboard := False
  else
    ARec^.hide_keyboard := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'selective');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.selective := False
  else
    ARec^.selective := AResData.AsBoolean;

end;


function ToJSONReplyKeyboardHide(ARec: PReplyKeyboardHide): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('hide_keyboard', ARec^.hide_keyboard);
  AResData.Add('selective', ARec^.selective);

  Result := AResData;
end;


procedure FillInlineKeyboardMarkup(ADataObject: TJSONObject;
  var ARec: PInlineKeyboardMarkup);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'inline_keyboard');
  if (AResData = nil) or (AResData.IsNull) then
    SetLength(ARec^.inline_keyboard, 0)
  else
  begin
    SetLength(ARec^.inline_keyboard, TJSONArray(AResData).Count);
    for I := 0 to Length(ARec^.inline_keyboard) - 1 do
    begin
      if (TJSONArray(AResData).Arrays[I] = nil) or
        (TJSONArray(AResData).Arrays[I].IsNull) then
        SetLength(ARec^.inline_keyboard[I], 0)
      else
      begin
        SetLength(ARec^.inline_keyboard[I], TJSONArray(AResData).Arrays[I].Count);
        for J := 0 to Length(ARec^.inline_keyboard[I]) - 1 do
        begin
          FillInlineKeyboardButton(TJSONArray(AResData).Arrays[I].Objects[J],
            ARec^.inline_keyboard[I][J]);
        end;
      end;
    end;
  end;

end;


function ToJSONInlineKeyboardMarkup(ARec: PInlineKeyboardMarkup): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  if ((ARec^.inline_keyboard <> nil) and (Length(ARec^.inline_keyboard) > 0)) then
  begin
    AResArray := TJSONArray.Create();
    for I := 0 to Length(ARec^.inline_keyboard) - 1 do
    begin
      BResArray := TJSONArray.Create();
      for J := 0 to Length(ARec^.inline_keyboard[I]) - 1 do
      begin
        BResArray.Add(ToJSONInlineKeyboardButton(ARec^.inline_keyboard[I][J]));
      end;
      AResArray.Add(BResArray);
    end;
    AResData.Add('inline_keyboard', AResArray);
  end;


  Result := AResData;
end;


procedure FillInlineKeyboardButton(ADataObject: TJSONObject;
  var ARec: PInlineKeyboardButton);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'text');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Text := ''
  else
    ARec^.Text := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.url := ''
  else
    ARec^.url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'callback_data');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.callback_data := ''
  else
    ARec^.callback_data := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'switch_inline_query');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.switch_inline_query := ''
  else
    ARec^.switch_inline_query := AResData.AsString;

end;


function ToJSONInlineKeyboardButton(ARec: PInlineKeyboardButton): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('text', ARec^.Text);
  AResData.Add('url', ARec^.url);
  AResData.Add('callback_data', ARec^.callback_data);
  AResData.Add('switch_inline_query', ARec^.switch_inline_query);

  Result := AResData;
end;


procedure FillCallbackQuery(ADataObject: TJSONObject; var ARec: PCallbackQuery);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'from');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.from := nil
  else
  begin
    New(ARec^.from);
    FillUser(TJSONObject(AResData), ARec^.from);
  end;
  AResData := GetJsonValue(ADataObject, 'message');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.message := nil
  else
  begin
    New(ARec^.message);
    FillMessage(TJSONObject(AResData), ARec^.message);
  end;
  AResData := GetJsonValue(ADataObject, 'inline_message_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.inline_message_id := ''
  else
    ARec^.inline_message_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'data');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Data := ''
  else
    ARec^.Data := AResData.AsString;

end;


function ToJSONCallbackQuery(ARec: PCallbackQuery): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('id', ARec^.id);
  if (ARec^.from <> nil) then
    AResData.Add('from', ToJSONUser(ARec^.from));
  if (ARec^.message <> nil) then
    AResData.Add('message', ToJSONMessage(ARec^.message));
  AResData.Add('inline_message_id', ARec^.inline_message_id);
  AResData.Add('data', ARec^.Data);

  Result := AResData;
end;


procedure FillForceReply(ADataObject: TJSONObject; var ARec: PForceReply);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'force_reply');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.force_reply := False
  else
    ARec^.force_reply := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'selective');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.selective := False
  else
    ARec^.selective := AResData.AsBoolean;

end;


function ToJSONForceReply(ARec: PForceReply): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('force_reply', ARec^.force_reply);
  AResData.Add('selective', ARec^.selective);

  Result := AResData;
end;


function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  Text: string; //Text of the message to be sent
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: integer;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'forwardMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'from_chat_id=' + IntToStr(from_chat_id) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: string;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'forwardMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'from_chat_id=' + from_chat_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: integer;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'forwardMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'from_chat_id=' + IntToStr(from_chat_id) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function forwardMessage(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  from_chat_id: string;
  //Unique identifier for the chat where the original message was sent (or channel username in the format @channelusername)
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  message_id: integer //Unique message identifier
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'forwardMessage';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'from_chat_id=' + from_chat_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendPhoto(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  photo: string;
  //Photo to send. You can either pass a file_id as String to Presend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
  Caption: string;
  //Photo caption (may also be used when resending photos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendPhoto';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'photo=' + photo + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendAudio(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  audio: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of the audio in seconds
  performer: string; //Performer
  title: string; //Track name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendAudio';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'audio=' + audio + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'performer=' + performer + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendDocument(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  document: string;
  //File to send. You can either pass a file_id as String to Presend a file that is already on the Telegram servers, or upload a new file using multipart/form-data.
  Caption: string;
  //Document caption (may also be used when resending documents by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendDocument';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'document=' + document + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendSticker(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  sticker: string;
  //Sticker to send. You can either pass a file_id as String to Presend a sticker that is already on the Telegram servers, or upload a new sticker using multipart/form-data.
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendSticker';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'sticker=' + sticker + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVideo(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  video: string;
  //Video to send. You can either pass a file_id as String to Presend a video that is already on the Telegram servers, or upload a new video file using multipart/form-data.
  duration: integer; //Duration of sent video in seconds
  Width: integer; //Video width
  Height: integer; //Video height
  Caption: string;
  //Video caption (may also be used when resending videos by file_id), 0-200 characters
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PDocument;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVideo';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'video=' + video + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'width=' + IntToStr(Width) + '&';
  GetQuery += 'height=' + IntToStr(Height) + '&';
  GetQuery += 'caption=' + Caption + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillDocument(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVoice(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  voice: string;
  //Audio file to send. You can either pass a file_id as String to Presend an audio that is already on the Telegram servers, or upload a new audio file using multipart/form-data.
  duration: integer; //Duration of sent audio in seconds
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PAudio;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVoice';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'voice=' + voice + '&';
  GetQuery += 'duration=' + IntToStr(duration) + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillAudio(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendLocation(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of location
  longitude: real; //Longitude of location
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendLocation';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendVenue(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  latitude: real; //Latitude of the venue
  longitude: real; //Longitude of the venue
  title: string; //Name of the venue
  address: string; //Address of the venue
  foursquare_id: string; //Foursquare identifier of the venue
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendVenue';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'latitude=' + '&';
  GetQuery += 'longitude=' + '&';
  GetQuery += 'title=' + title + '&';
  GetQuery += 'address=' + address + '&';
  GetQuery += 'foursquare_id=' + foursquare_id + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PInlineKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardMarkup
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PReplyKeyboardHide
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONReplyKeyboardHide(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendContact(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  phone_number: string; //Contact's phone number
  first_name: string; //Contact's first name
  last_name: string; //Contact's last name
  disable_notification: boolean;
  //Sends the message Psilently. iOS users will not receive a notification, Android users will receive a notification with no sound.
  reply_to_message_id: integer; //If the message is a reply, ID of the original message
  reply_markup: PForceReply
  //Additional interface options. A JSON-serialized object for an Pinline keyboard, Pcustom reply keyboard, instructions to hide keyboard or to force a reply from the user.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendContact';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'phone_number=' + phone_number + '&';
  GetQuery += 'first_name=' + first_name + '&';
  GetQuery += 'last_name=' + last_name + '&';
  GetQuery += 'disable_notification=' + BoolToStr(disable_notification, True) + '&';
  GetQuery += 'reply_to_message_id=' + IntToStr(reply_to_message_id) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONForceReply(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function sendChatAction(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  action: string
  //Type of action to broadcast. Choose one, depending on what the user is about to receive: typing for Ptext messages, upload_photo for Pphotos, record_video or upload_video for Pvideos, record_audio or upload_audio for Paudio files, upload_document for Pgeneral files, find_location for Plocation data.
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendChatAction';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'action=' + action;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function sendChatAction(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  action: string
  //Type of action to broadcast. Choose one, depending on what the user is about to receive: typing for Ptext messages, upload_photo for Pphotos, record_video or upload_video for Pvideos, record_audio or upload_audio for Paudio files, upload_document for Pgeneral files, find_location for Plocation data.
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'sendChatAction';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'action=' + action;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function getUserProfilePhotos(ABaseUrl: string; // Base Url To Telegram Bot
  user_id: integer; //Unique identifier of the target user
  offset: integer;
  //Sequential number of the first photo to be returned. By default, all photos are returned.
  limit: integer
  //Limits the number of photos to be retrieved. Values between 1—100 are accepted. Defaults to 100.
  ): PUserProfilePhotos;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'getUserProfilePhotos';
  GetQuery := '';
  GetQuery += 'user_id=' + IntToStr(user_id) + '&';
  GetQuery += 'offset=' + IntToStr(offset) + '&';
  GetQuery += 'limit=' + IntToStr(limit);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillUserProfilePhotos(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function getFile(ABaseUrl: string; // Base Url To Telegram Bot
  file_id: string //File identifier to get info about
  ): PFile;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'getFile';
  GetQuery := '';
  GetQuery += 'file_id=' + file_id;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillFile(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function kickChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'kickChatMember';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'user_id=' + IntToStr(user_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function kickChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'kickChatMember';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'user_id=' + IntToStr(user_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function unbanChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'unbanChatMember';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'user_id=' + IntToStr(user_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function unbanChatMember(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Unique identifier for the target group or username of the target supergroup (in the format @supergroupusername)
  user_id: integer //Unique identifier of the target user
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'unbanChatMember';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'user_id=' + IntToStr(user_id);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function answerCallbackQuery(ABaseUrl: string; // Base Url To Telegram Bot
  callback_query_id: string; //Unique identifier for the query to be answered
  Text: string;
  //Text of the notification. If not specified, nothing will be shown to the user
  show_alert: boolean
  //If true, an alert will be shown by the client instead of a notification at the top of the chat screen. Defaults to false.
  ): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'answerCallbackQuery';
  GetQuery := '';
  GetQuery += 'callback_query_id=' + callback_query_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'show_alert=' + BoolToStr(show_alert, True);
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

function editMessageText(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Text: string; //New text of the message
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageText';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function editMessageText(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Text: string; //New text of the message
  parse_mode: string;
  //Send PMarkdown or PHTML, if you want Telegram apps to show Pbold, italic, fixed-width text or inline URLs in your bot's message.
  disable_web_page_preview: boolean; //Disables link previews for links in this message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageText';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  GetQuery += 'text=' + Text + '&';
  GetQuery += 'parse_mode=' + parse_mode + '&';
  GetQuery += 'disable_web_page_preview=' +
    BoolToStr(disable_web_page_preview, True) + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function editMessageCaption(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Caption: string; //New caption of the message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageCaption';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  GetQuery += 'caption=' + Caption + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function editMessageCaption(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  Caption: string; //New caption of the message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageCaption';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  GetQuery += 'caption=' + Caption + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function editMessageReplyMarkup(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: integer;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageReplyMarkup';
  GetQuery := '';
  GetQuery += 'chat_id=' + IntToStr(chat_id) + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

function editMessageReplyMarkup(ABaseUrl: string; // Base Url To Telegram Bot
  chat_id: string;
  //Required if inline_message_id is not specified. Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  message_id: integer;
  //Required if inline_message_id is not specified. Unique identifier of the sent message
  inline_message_id: string;
  //Required if chat_id and message_id are not specified. Identifier of the inline message
  reply_markup: PInlineKeyboardMarkup
  //A JSON-serialized object for an Pinline keyboard.
  ): PMessage;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'editMessageReplyMarkup';
  GetQuery := '';
  GetQuery += 'chat_id=' + chat_id + '&';
  GetQuery += 'message_id=' + IntToStr(message_id) + '&';
  GetQuery += 'inline_message_id=' + inline_message_id + '&';
  if (reply_markup <> nil) then
    GetQuery += 'reply_markup=' + ToJSONInlineKeyboardMarkup(reply_markup).AsJSON;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  new(Result);
  FillMessage(GetJsonValue(JsonStringToJsonData(ResultString), 'result') as
    TJSONObject, Result);
end;

procedure FillInlineQuery(ADataObject: TJSONObject; var ARec: PInlineQuery);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'from');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.from := nil
  else
  begin
    New(ARec^.from);
    FillUser(TJSONObject(AResData), ARec^.from);
  end;
  AResData := GetJsonValue(ADataObject, 'location');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.location := nil
  else
  begin
    New(ARec^.location);
    FillLocation(TJSONObject(AResData), ARec^.location);
  end;
  AResData := GetJsonValue(ADataObject, 'query');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.query := ''
  else
    ARec^.query := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'offset');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.offset := ''
  else
    ARec^.offset := AResData.AsString;

end;


function ToJSONInlineQuery(ARec: PInlineQuery): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('id', ARec^.id);
  if (ARec^.from <> nil) then
    AResData.Add('from', ToJSONUser(ARec^.from));
  if (ARec^.location <> nil) then
    AResData.Add('location', ToJSONLocation(ARec^.location));
  AResData.Add('query', ARec^.query);
  AResData.Add('offset', ARec^.offset);

  Result := AResData;
end;


function answerInlineQuery(ABaseUrl: string; inline_query_id: string;
  results: array of PInlineQueryResult; cache_time: integer;
  is_personal: boolean; next_offset: string; switch_pm_text: string;
  switch_pm_parameter: string): boolean;
var
  MethodURL: string;
  GetQuery: string;
  ResultString: string;
begin
  MethodURL := ABaseUrl + 'answerInlineQuery';
  GetQuery := '';
  GetQuery += 'inline_query_id=' + inline_query_id + '&';
  GetQuery += 'results=' + '&';
  GetQuery += 'cache_time=' + IntToStr(cache_time) + '&';
  GetQuery += 'is_personal=' + BoolToStr(is_personal, True) + '&';
  GetQuery += 'next_offset=' + next_offset + '&';
  GetQuery += 'switch_pm_text=' + switch_pm_text + '&';
  GetQuery += 'switch_pm_parameter=' + switch_pm_parameter;
  ResultString := Request(MethodURL, 'POST', GetQuery);
  Result := GetJsonValue(JsonStringToJsonData(ResultString), 'result').AsBoolean;
end;

procedure FillInlineQueryResult(ADataObject: TJSONObject; var ARec: PInlineQueryResult);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.url := ''
  else
    ARec^.url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'hide_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.hide_url := False
  else
    ARec^.hide_url := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResult(ARec: PInlineQueryResult): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('title', ARec^.title);
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  AResData.Add('url', ARec^.url);
  AResData.Add('hide_url', ARec^.hide_url);
  AResData.Add('description', ARec^.description);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultArticle(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultArticle);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.url := ''
  else
    ARec^.url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'hide_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.hide_url := False
  else
    ARec^.hide_url := AResData.AsBoolean;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResultArticle(ARec: PInlineQueryResultArticle): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('title', ARec^.title);
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  AResData.Add('url', ARec^.url);
  AResData.Add('hide_url', ARec^.hide_url);
  AResData.Add('description', ARec^.description);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultPhoto(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultPhoto);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'photo_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.photo_url := ''
  else
    ARec^.photo_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'photo_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.photo_width := -1
  else
    ARec^.photo_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'photo_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.photo_height := -1
  else
    ARec^.photo_height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultPhoto(ARec: PInlineQueryResultPhoto): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('photo_url', ARec^.photo_url);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('photo_width', ARec^.photo_width);
  AResData.Add('photo_height', ARec^.photo_height);
  AResData.Add('title', ARec^.title);
  AResData.Add('description', ARec^.description);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultGif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultGif);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'gif_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.gif_url := ''
  else
    ARec^.gif_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'gif_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.gif_width := -1
  else
    ARec^.gif_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'gif_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.gif_height := -1
  else
    ARec^.gif_height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillinputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultGif(ARec: PInlineQueryResultGif): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('gif_url', ARec^.gif_url);
  AResData.Add('gif_width', ARec^.gif_width);
  AResData.Add('gif_height', ARec^.gif_height);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONinputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultMpeg4Gif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultMpeg4Gif);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mpeg4_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mpeg4_url := ''
  else
    ARec^.mpeg4_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mpeg4_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mpeg4_width := -1
  else
    ARec^.mpeg4_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'mpeg4_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mpeg4_height := -1
  else
    ARec^.mpeg4_height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultMpeg4Gif(ARec: PInlineQueryResultMpeg4Gif): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('mpeg4_url', ARec^.mpeg4_url);
  AResData.Add('mpeg4_width', ARec^.mpeg4_width);
  AResData.Add('mpeg4_height', ARec^.mpeg4_height);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultVideo(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVideo);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'video_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video_url := ''
  else
    ARec^.video_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'video_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video_width := -1
  else
    ARec^.video_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'video_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video_height := -1
  else
    ARec^.video_height := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'video_duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video_duration := -1
  else
    ARec^.video_duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultVideo(ARec: PInlineQueryResultVideo): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('video_url', ARec^.video_url);
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  AResData.Add('video_width', ARec^.video_width);
  AResData.Add('video_height', ARec^.video_height);
  AResData.Add('video_duration', ARec^.video_duration);
  AResData.Add('description', ARec^.description);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultAudio(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultAudio);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'audio_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.audio_url := ''
  else
    ARec^.audio_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'performer');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.performer := ''
  else
    ARec^.performer := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'audio_duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.audio_duration := -1
  else
    ARec^.audio_duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultAudio(ARec: PInlineQueryResultAudio): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('audio_url', ARec^.audio_url);
  AResData.Add('title', ARec^.title);
  AResData.Add('performer', ARec^.performer);
  AResData.Add('audio_duration', ARec^.audio_duration);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultVoice(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVoice);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'voice_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.voice_url := ''
  else
    ARec^.voice_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'voice_duration');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.voice_duration := -1
  else
    ARec^.voice_duration := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultVoice(ARec: PInlineQueryResultVoice): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('voice_url', ARec^.voice_url);
  AResData.Add('title', ARec^.title);
  AResData.Add('voice_duration', ARec^.voice_duration);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultDocument(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultDocument);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'document_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.document_url := ''
  else
    ARec^.document_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mime_type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mime_type := ''
  else
    ARec^.mime_type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResultDocument(ARec: PInlineQueryResultDocument): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  AResData.Add('document_url', ARec^.document_url);
  AResData.Add('mime_type', ARec^.mime_type);
  AResData.Add('description', ARec^.description);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultLocation(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultLocation);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'latitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.latitude := -1
  else
    ARec^.latitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'longitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.longitude := -1
  else
    ARec^.longitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResultLocation(ARec: PInlineQueryResultLocation): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('latitude', ARec^.latitude);
  AResData.Add('longitude', ARec^.longitude);
  AResData.Add('title', ARec^.title);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultVenue(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultVenue);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'latitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.latitude := -1
  else
    ARec^.latitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'longitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.longitude := -1
  else
    ARec^.longitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'address');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.address := ''
  else
    ARec^.address := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'foursquare_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.foursquare_id := ''
  else
    ARec^.foursquare_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResultVenue(ARec: PInlineQueryResultVenue): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('latitude', ARec^.latitude);
  AResData.Add('longitude', ARec^.longitude);
  AResData.Add('title', ARec^.title);
  AResData.Add('address', ARec^.address);
  AResData.Add('foursquare_id', ARec^.foursquare_id);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultContact(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultContact);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'phone_number');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.phone_number := ''
  else
    ARec^.phone_number := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'first_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.first_name := ''
  else
    ARec^.first_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'last_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.last_name := ''
  else
    ARec^.last_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;
  AResData := GetJsonValue(ADataObject, 'thumb_url');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_url := ''
  else
    ARec^.thumb_url := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'thumb_width');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_width := -1
  else
    ARec^.thumb_width := AResData.AsInteger;
  AResData := GetJsonValue(ADataObject, 'thumb_height');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.thumb_height := -1
  else
    ARec^.thumb_height := AResData.AsInteger;

end;


function ToJSONInlineQueryResultContact(ARec: PInlineQueryResultContact): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('phone_number', ARec^.phone_number);
  AResData.Add('first_name', ARec^.first_name);
  AResData.Add('last_name', ARec^.last_name);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));
  AResData.Add('thumb_url', ARec^.thumb_url);
  AResData.Add('thumb_width', ARec^.thumb_width);
  AResData.Add('thumb_height', ARec^.thumb_height);

  Result := AResData;
end;


procedure FillInlineQueryResultCachedPhoto(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedPhoto);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'photo_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.photo_file_id := ''
  else
    ARec^.photo_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedPhoto(
  ARec: PInlineQueryResultCachedPhoto): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('photo_file_id', ARec^.photo_file_id);
  AResData.Add('title', ARec^.title);
  AResData.Add('description', ARec^.description);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedGif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedGif);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'gif_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.gif_file_id := ''
  else
    ARec^.gif_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedGif(ARec: PInlineQueryResultCachedGif): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('gif_file_id', ARec^.gif_file_id);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedMpeg4Gif(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedMpeg4Gif);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'mpeg4_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.mpeg4_file_id := ''
  else
    ARec^.mpeg4_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedMpeg4Gif(
  ARec: PInlineQueryResultCachedMpeg4Gif): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('mpeg4_file_id', ARec^.mpeg4_file_id);
  AResData.Add('title', ARec^.title);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedSticker(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedSticker);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'sticker_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.sticker_file_id := ''
  else
    ARec^.sticker_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedSticker(
  ARec: PInlineQueryResultCachedSticker): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('sticker_file_id', ARec^.sticker_file_id);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedDocument(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedDocument);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'document_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.document_file_id := ''
  else
    ARec^.document_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedDocument(
  ARec: PInlineQueryResultCachedDocument): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('title', ARec^.title);
  AResData.Add('document_file_id', ARec^.document_file_id);
  AResData.Add('description', ARec^.description);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedVideo(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedVideo);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'video_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.video_file_id := ''
  else
    ARec^.video_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'description');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.description := ''
  else
    ARec^.description := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'caption');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.Caption := ''
  else
    ARec^.Caption := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedVideo(
  ARec: PInlineQueryResultCachedVideo): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('video_file_id', ARec^.video_file_id);
  AResData.Add('title', ARec^.title);
  AResData.Add('description', ARec^.description);
  AResData.Add('caption', ARec^.Caption);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedVoice(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedVoice);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'voice_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.voice_file_id := ''
  else
    ARec^.voice_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedVoice(
  ARec: PInlineQueryResultCachedVoice): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('voice_file_id', ARec^.voice_file_id);
  AResData.Add('title', ARec^.title);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInlineQueryResultCachedAudio(ADataObject: TJSONObject;
  var ARec: PInlineQueryResultCachedAudio);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'type');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^._type := ''
  else
    ARec^._type := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.id := ''
  else
    ARec^.id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'audio_file_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.audio_file_id := ''
  else
    ARec^.audio_file_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'reply_markup');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.reply_markup := nil
  else
  begin
    New(ARec^.reply_markup);
    FillInlineKeyboardMarkup(TJSONObject(AResData), ARec^.reply_markup);
  end;
  AResData := GetJsonValue(ADataObject, 'input_message_content');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.input_message_content := nil
  else
  begin
    New(ARec^.input_message_content);
    FillInputMessageContent(TJSONObject(AResData), ARec^.input_message_content);
  end;

end;


function ToJSONInlineQueryResultCachedAudio(
  ARec: PInlineQueryResultCachedAudio): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('type', ARec^._type);
  AResData.Add('id', ARec^.id);
  AResData.Add('audio_file_id', ARec^.audio_file_id);
  if (ARec^.reply_markup <> nil) then
    AResData.Add('reply_markup', ToJSONInlineKeyboardMarkup(ARec^.reply_markup));
  if (ARec^.input_message_content <> nil) then
    AResData.Add('input_message_content', ToJSONInputMessageContent(
      ARec^.input_message_content));

  Result := AResData;
end;


procedure FillInputMessageContent(ADataObject: TJSONObject;
  var ARec: PInputMessageContent);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'message_text');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.message_text := ''
  else
    ARec^.message_text := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'parse_mode');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.parse_mode := ''
  else
    ARec^.parse_mode := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'disable_web_page_preview');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.disable_web_page_preview := False
  else
    ARec^.disable_web_page_preview := AResData.AsBoolean;

end;


function ToJSONInputMessageContent(ARec: PInputMessageContent): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('message_text', ARec^.message_text);
  AResData.Add('parse_mode', ARec^.parse_mode);
  AResData.Add('disable_web_page_preview', ARec^.disable_web_page_preview);

  Result := AResData;
end;


procedure FillInputTextMessageContent(ADataObject: TJSONObject;
  var ARec: PInputTextMessageContent);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'message_text');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.message_text := ''
  else
    ARec^.message_text := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'parse_mode');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.parse_mode := ''
  else
    ARec^.parse_mode := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'disable_web_page_preview');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.disable_web_page_preview := False
  else
    ARec^.disable_web_page_preview := AResData.AsBoolean;

end;


function ToJSONInputTextMessageContent(ARec: PInputTextMessageContent): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('message_text', ARec^.message_text);
  AResData.Add('parse_mode', ARec^.parse_mode);
  AResData.Add('disable_web_page_preview', ARec^.disable_web_page_preview);

  Result := AResData;
end;


procedure FillInputLocationMessageContent(ADataObject: TJSONObject;
  var ARec: PInputLocationMessageContent);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'latitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.latitude := -1
  else
    ARec^.latitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'longitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.longitude := -1
  else
    ARec^.longitude := AResData.AsFloat;

end;


function ToJSONInputLocationMessageContent(ARec: PInputLocationMessageContent): TJSONData;

var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('latitude', ARec^.latitude);
  AResData.Add('longitude', ARec^.longitude);

  Result := AResData;
end;


procedure FillInputVenueMessageContent(ADataObject: TJSONObject;
  var ARec: PInputVenueMessageContent);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'latitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.latitude := -1
  else
    ARec^.latitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'longitude');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.longitude := -1
  else
    ARec^.longitude := AResData.AsFloat;
  AResData := GetJsonValue(ADataObject, 'title');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.title := ''
  else
    ARec^.title := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'address');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.address := ''
  else
    ARec^.address := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'foursquare_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.foursquare_id := ''
  else
    ARec^.foursquare_id := AResData.AsString;

end;


function ToJSONInputVenueMessageContent(ARec: PInputVenueMessageContent): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('latitude', ARec^.latitude);
  AResData.Add('longitude', ARec^.longitude);
  AResData.Add('title', ARec^.title);
  AResData.Add('address', ARec^.address);
  AResData.Add('foursquare_id', ARec^.foursquare_id);

  Result := AResData;
end;


procedure FillInputContactMessageContent(ADataObject: TJSONObject;
  var ARec: PInputContactMessageContent);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'phone_number');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.phone_number := ''
  else
    ARec^.phone_number := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'first_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.first_name := ''
  else
    ARec^.first_name := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'last_name');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.last_name := ''
  else
    ARec^.last_name := AResData.AsString;

end;


function ToJSONInputContactMessageContent(ARec: PInputContactMessageContent): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('phone_number', ARec^.phone_number);
  AResData.Add('first_name', ARec^.first_name);
  AResData.Add('last_name', ARec^.last_name);

  Result := AResData;
end;


procedure FillChosenInlineResult(ADataObject: TJSONObject;
  var ARec: PChosenInlineResult);
var
  AResData: TJSONData;
  I, J: integer;
begin
  AResData := GetJsonValue(ADataObject, 'result_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.result_id := ''
  else
    ARec^.result_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'from');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.from := nil
  else
  begin
    New(ARec^.from);
    FillUser(TJSONObject(AResData), ARec^.from);
  end;
  AResData := GetJsonValue(ADataObject, 'location');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.location := nil
  else
  begin
    New(ARec^.location);
    FillLocation(TJSONObject(AResData), ARec^.location);
  end;
  AResData := GetJsonValue(ADataObject, 'inline_message_id');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.inline_message_id := ''
  else
    ARec^.inline_message_id := AResData.AsString;
  AResData := GetJsonValue(ADataObject, 'query');
  if (AResData = nil) or (AResData.IsNull) then
    ARec^.query := ''
  else
    ARec^.query := AResData.AsString;

end;


function ToJSONChosenInlineResult(ARec: PChosenInlineResult): TJSONData;
var
  AResData: TJSONObject;
  AResArray, BResArray: TJSONArray;
  I, J: integer;
begin
  if (ARec = nil) then
  begin
    Result := nil;
    exit;
  end;
  AResData := TJSONObject.Create();
  AResData.Add('result_id', ARec^.result_id);
  if (ARec^.from <> nil) then
    AResData.Add('from', ToJSONUser(ARec^.from));
  if (ARec^.location <> nil) then
    AResData.Add('location', ToJSONLocation(ARec^.location));
  AResData.Add('inline_message_id', ARec^.inline_message_id);
  AResData.Add('query', ARec^.query);

  Result := AResData;
end;


end.
