-- 
-- Instagram 埋め込みHTML取得AppleScript
-- 
-- 必須ツール
--   curl
--   jq (brew install jq)
--   tidy (brew install tidy-html5)
-- 
-- ※動作無保証ツールです。ご自由に改変してご利用ください。
-- 

display dialog ¬
	"InstagramのURLは？
※結果のHTMLはクリップボードにコピーされます。" default button 2 ¬
	default answer ¬
	"" with icon note
set instagramPageUrl to text returned of result

if instagramPageUrl = "" then
	beep
	display dialog ¬
		"URLを指定してください。" buttons {"終了"} ¬
		default button 1 ¬
		with icon stop
	return
end if

if not {instagramPageUrl starts with "https://www.instagram.com/p/"} then
	beep
	display dialog ¬
		"URLはInstagramの写真ページを指定してください。" buttons {"終了"} ¬
		default button 1 ¬
		with icon stop
	return
end if

set instagramOEmbedUrl to "https://api.instagram.com/oembed/?url=" & instagramPageUrl

do shell script "/usr/bin/curl -s " & instagramOEmbedUrl & " | /usr/local/bin/jq -r \".html\" | /usr/local/bin/tidy -i -utf8 -w 0 -xml -ashtml"
set instagramEmbedHtml to result
if instagramEmbedHtml = "" then
	beep
	display dialog ¬
		"何かしらのエラーでHTMLが取得できませんでした。" buttons {"終了"} ¬
		default button 1 ¬
		with icon caution
	return
end if
set the clipboard to instagramEmbedHtml

display dialog "HTMLをクリップボードにコピーしました。" buttons {"終了"} ¬
	default button 1 ¬
	with icon note