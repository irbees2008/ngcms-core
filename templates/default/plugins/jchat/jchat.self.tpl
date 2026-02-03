<!DOCTYPE html PUBLIC "-//W3C//DTDXHTML1.0Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{{ lang.langcode }}" lang="{{ lang.langcode }}" dir="ltr">
	<head>
		<meta http-equiv="content-type" content="text/html; charset={{ lang.encoding }}"/>
		<meta http-equiv="content-language" content="{{ lang.langcode }}"/>
		<meta name="generator" content="NGCMS jChat plugin"/>
		<meta name="document-state" content="dynamic"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<link href="{{ tpl_url }}/style.css" rel="stylesheet" type="text/css" media="screen"/>
		<link href="{{ home }}/rss.xml" rel="alternate" type="application/rss+xml" title="RSS"/>
		 <script type="text/javascript" src="{{ scriptLibrary }}/functions.js"></script>
		 <script type="text/javascript" src="{{ scriptLibrary }}/ajax.js"></script>
			<title>
		Чат - Next Generation CMS
		</title>
		<!-- STYLE DEFINITION BEGIN ((( YOU CAN CHANGE IT ))) -->
			<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}
body {
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 20px;
}
#jChatTable {
	width: 100%;
	border-spacing: 0;
	padding: 0;
}
.jchat_ODD,
.jchat_EVEN {
	margin-bottom: 15px;
	display: block;
}
.jchat_ODD TD,
.jchat_EVEN TD {
	background: transparent;
	border: none;
	padding: 0;
	vertical-align: top;
	display: flex;
}
.jchat_message_wrapper {
	display: flex;
	align-items: flex-start;
	margin-bottom: 15px;
	animation: messageSlide 0.3s ease-out;
}

.jchat_message_wrapper.jchat_own {
	flex-direction: row-reverse;
	margin-left: auto;
	margin-right: 0;
}

.jchat_message_wrapper.jchat_own .jchat_avatar {
	margin-right: 0;
	margin-left: 10px;
}

.jchat_message_wrapper.jchat_own .jchat_message_content {
	align-items: flex-end;
}

.jchat_message_wrapper.jchat_own .jchat_message_bubble {
	background: linear-gradient(135deg, #34c759 0%, #30d158 100%);
	border-top-left-radius: 18px;
	border-top-right-radius: 4px;
}

.jchat_message_wrapper.jchat_own .jchat_message_bubble::before {
	left: auto;
	right: -8px;
	border-width: 0 0 12px 12px;
	border-color: transparent transparent transparent #34c759;
}

.jchat_message_wrapper.jchat_own .jchat_message_meta {
	justify-content: flex-end;
}

@keyframes messageSlide {
	from {
		opacity: 0;
		transform: translateY(10px);
	}
	to {
		opacity: 1;
		transform: translateY(0);
	}
}
.jchat_avatar {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	margin-right: 10px;
	object-fit: cover;
	border: 2px solid #e0e0e0;
	flex-shrink: 0;
}
.jchat_message_content {
	flex: 1;
	max-width: 70%;
}
.jchat_message_bubble {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: #fff;
	padding: 12px 16px;
	border-radius: 18px;
	border-top-left-radius: 4px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	word-wrap: break-word;
	position: relative;
	margin-bottom: 4px;
}
.jchat_message_bubble::before {
	content: '';
	position: absolute;
	left: -8px;
	top: 0;
	width: 0;
	height: 0;
	border-style: solid;
	border-width: 0 12px 12px 0;
	border-color: transparent #667eea transparent transparent;
}
.jchat_userName {
	font-weight: 600;
	font-size: 13px;
	color: #fff;
	margin-bottom: 4px;
	display: block;
	cursor: pointer;
	opacity: 0.9;
}
.jchat_userName:hover {
	opacity: 1;
}
.jchat_message_text {
	font-size: 14px;
	line-height: 1.5;
}
.jchat_message_meta {
	font-size: 11px;
	color: #999;
	margin-top: 2px;
	display: flex;
	align-items: center;
	gap: 8px;
}
.jchat_delete_btn {
	color: #f44336;
	cursor: pointer;
	text-decoration: none;
	font-size: 11px;
	padding: 2px 6px;
	border-radius: 4px;
	transition: background 0.2s;
}
.jchat_delete_btn:hover {
	background: rgba(244, 67, 54, 0.1);
}
.jchat_INFO TD {
	background-color: #fff3cd;
	border: 1px solid #ffc107;
	padding: 8px 12px;
	border-radius: 8px;
	font-size: 12px;
	color: #856404;
	text-align: center;
	margin: 10px 0;
	display: block;
}
#jChatTable img {
	vertical-align: top;
}
.jchat_container {
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
	max-width: 1000px;
	width: 100%;
	max-height: 90vh;
	display: flex;
	flex-direction: column;
}
.jchat_header {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
	color: white;
	font-weight: 600;
	font-size: 20px;
}
.jchat_messages_area {
	background: #f5f7fa;
	padding: 20px;
	flex: 1;
	overflow-y: auto;
	overflow-x: hidden;
}
.jchat_messages_area::-webkit-scrollbar {
	width: 8px;
}
.jchat_messages_area::-webkit-scrollbar-track {
	background: #f1f1f1;
}
.jchat_messages_area::-webkit-scrollbar-thumb {
	background: #888;
	border-radius: 4px;
}
.jchat_messages_area::-webkit-scrollbar-thumb:hover {
	background: #555;
}
.jchat_input_area {
	background: #fff;
	padding: 20px;
	border-top: 1px solid #e0e0e0;
}
.jchat_input_area input[type="text"],
.jchat_input_area textarea {
	width: 100%;
	padding: 12px 16px;
	border: 1px solid #e0e0e0;
	border-radius: 24px;
	font-size: 14px;
	font-family: inherit;
	resize: none;
	transition: border-color 0.2s;
	box-sizing: border-box;
}
.jchat_input_area input[type="text"]:focus,
.jchat_input_area textarea:focus {
	outline: none;
	border-color: #667eea;
}
.jchat_input_area textarea {
	border-radius: 12px;
}
.jchat_input_area input[type="submit"] {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	border: none;
	padding: 12px 32px;
	border-radius: 24px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	transition: transform 0.2s, box-shadow 0.2s;
	margin-top: 8px;
}
.jchat_input_area input[type="submit"]:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}
.jchat_input_area input[type="submit"]:active {
	transform: translateY(0);
}
.jchat_char_count {
	font-size: 12px;
	color: #999;
	text-align: right;
	margin-top: 4px;
}

/* Emoji picker styles */
.jchat_emoji_picker {
	position: relative;
	display: inline-block;
	margin-top: 8px;
}

.jchat_emoji_btn {
	background: #f5f7fa;
	border: 1px solid #e0e0e0;
	border-radius: 50%;
	width: 36px;
	height: 36px;
	font-size: 20px;
	cursor: pointer;
	transition: all 0.2s;
	display: flex;
	align-items: center;
	justify-content: center;
}

.jchat_emoji_btn:hover {
	background: #e8ecf1;
	transform: scale(1.05);
}

.jchat_emoji_panel {
	display: none;
	position: absolute;
	bottom: 45px;
	left: 0;
	background: white;
	border: 1px solid #e0e0e0;
	border-radius: 12px;
	padding: 8px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	z-index: 1000;
	min-width: 280px;
}

.jchat_emoji_panel.show {
	display: block;
	animation: emojiSlide 0.2s ease-out;
}

@keyframes emojiSlide {
	from {
		opacity: 0;
		transform: translateY(10px);
	}
	to {
		opacity: 1;
		transform: translateY(0);
	}
}

.jchat_emoji_grid {
	display: grid;
	grid-template-columns: repeat(8, 1fr);
	gap: 4px;
	max-height: 200px;
	overflow-y: auto;
}

.jchat_emoji_item {
	font-size: 24px;
	cursor: pointer;
	padding: 4px;
	text-align: center;
	border-radius: 6px;
	transition: all 0.2s;
	user-select: none;
}

.jchat_emoji_item:hover {
	background: #f5f7fa;
	transform: scale(1.2);
}

.jchat_bottom_controls {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-top: 8px;
}
	</style>
		<!-- STYLE DEFINITION END ((( YOU CAN CHANGE IT ))) -->
	</head>
	<body>
		<!-- SCRIPTS INTERNALS BEGIN ((( DO NOT CHANGE ))) -->
		{% include 'plugins/jchat/jchat.script.header.tpl' %}
		 <script language="javascript">
		var jChatInputUsernameDefault = 0;
		
		var jchatEmojis = [
			'😀','😃','😄','😁','😆','😅','🤣','😂',
			'🙂','🙃','😉','😊','😇','🥰','😍','🤩',
			'😘','😗','😚','😙','😋','😛','😜','🤪',
			'😝','🤑','🤗','🤭','🤫','🤔','🤐','🤨',
			'😐','😑','😶','😏','😒','🙄','😬','🤥',
			'😌','😔','😪','🤤','😴','😷','🤒','🤕',
			'🤢','🤮','🤧','🥵','🥶','🥴','😵','🤯',
			'🤠','🥳','😎','🤓','🧐','😕','😟','🙁',
			'☹️','😮','😯','😲','😳','🥺','😦','😧',
			'😨','😰','😥','😢','😭','😱','😖','😣',
			'😞','😓','😩','😫','🥱','😤','😡','😠',
			'🤬','😈','👿','💀','☠️','💩','🤡','👹',
			'👺','👻','👽','👾','🤖','😺','😸','😹',
			'😻','😼','😽','🙀','😿','😾','❤️','🧡',
			'💛','💚','💙','💜','🖤','🤍','🤎','💔',
			'❣️','💕','💞','💓','💗','💖','💘','💝',
			'👍','👎','👌','✌️','🤞','🤟','🤘','🤙',
			'👈','👉','👆','👇','☝️','✋','🤚','🖐️',
			'🖖','👋','🤙','💪','🦾','🖕','✍️','🙏',
			'💋','👄','🦷','👅','👂','🦻','👃','👣',
			'👁️','👀','🧠','🦴','👤','👥','🗣️','👶',
			'🎉','🎊','🎈','🎁','🏆','🥇','🥈','🥉',
			'⚽','🏀','🏈','⚾','🎾','🏐','🏉','🎱',
			'🔥','💧','⭐','✨','🌟','💫','⚡','☄️'
		];
		
		function jchatToggleEmojiPanel() {
			var panel = document.getElementById('jchatEmojiPanel');
			if (panel) {
				panel.classList.toggle('show');
			}
		}
		
		function jchatInsertEmoji(emoji) {
			var textArea = document.getElementById('jChatText');
			if (textArea) {
				var start = textArea.selectionStart;
				var end = textArea.selectionEnd;
				var text = textArea.value;
				textArea.value = text.substring(0, start) + emoji + text.substring(end);
				textArea.selectionStart = textArea.selectionEnd = start + emoji.length;
				textArea.focus();
				jchatCalculateMaxLen(textArea, 'jchatWLen', {{ maxlen }});
			}
			jchatToggleEmojiPanel();
		}
		
		function jchatInitEmojiPicker() {
			var grid = document.getElementById('jchatEmojiGrid');
			if (!grid) return;
			grid.innerHTML = '';
			for (var i = 0; i < jchatEmojis.length; i++) {
				var item = document.createElement('div');
				item.className = 'jchat_emoji_item';
				item.textContent = jchatEmojis[i];
				item.onclick = (function(emoji) {
					return function() { jchatInsertEmoji(emoji); };
				})(jchatEmojis[i]);
				grid.appendChild(item);
			}
		}
		
		document.addEventListener('click', function(e) {
			var panel = document.getElementById('jchatEmojiPanel');
			var btn = document.getElementById('jchatEmojiBtn');
			if (panel && btn && !panel.contains(e.target) && !btn.contains(e.target)) {
				panel.classList.remove('show');
			}
		});
		
		// Override chatSubmitForm to handle both logged and not logged users
		function chatSubmitForm() {
			var formID = document.getElementById('jChatForm');
			{% if logged %}
			CHATTER.postMessage('', formID.text.value);
			{% else %}
			CHATTER.postMessage(formID.name.value, formID.text.value);
			{% endif %}
			return false;
		}
												// Function to calculate remaining characters
												function jchatCalculateMaxLen(oId, tName, maxLen) {
													var delta = maxLen - oId.value.length;
													var tId = document.getElementById(tName);
													if (tId) {
														tId.innerHTML = delta;
														tId.style.color = (delta > 0) ? '#999' : 'red';
													}
												}
												// Function to insert username when clicking on it
												function jchatProcessAreaClick(event) {
													var evt = event ? event : window.event;
													if (!evt) return;
													var trg = evt.target ? evt.target : evt.srcElement;
													if (!trg) return;
													if (trg.className != 'jchat_userName') return;
													var mText = document.getElementById('jChatText');
													if (mText) {
														mText.value += '@' + trg.innerHTML + ': ';
														mText.focus();
													}
												}
												</script>
		<!-- SCRIPTS INTERNALS END -->
		<!-- Display data definition (( YOU CAN CHANGE IT )) -->
			<div class="jchat_container"> <div class="jchat_header">
				💬 Чат
			</div>
			<div id="jChatMessages" class="jchat_messages_area" onclick="jchatProcessAreaClick(event);">
				<table id="jChatTable" style="width: 100%; border: 0; border-spacing: 0;">
					<tbody id="jChatTableBody">
						<tr>
							<td>Loading chat...</td>
						</tr>
					</tbody>
				</table>
			</div>
			{% if post_enabled %}
				<div class="jchat_input_area">
					<form method="post" name="jChatForm" id="jChatForm" onsubmit="chatSubmitForm(); return false;">
						{% if not logged %}
							<input type="text" name="name" maxlength="20" style="margin-bottom: 8px;" placeholder="{{ lang.jchat.input.username }}" value="{{ lang.jchat.input.username }}" onfocus="if(!jChatInputUsernameDefault){this.value='';jChatInputUsernameDefault=1;}"/>
						{% endif %}
						<textarea id="jChatText" name="text" rows="3" placeholder="Введите сообщение..." onfocus="jchatCalculateMaxLen(this,'jchatWLen', {{ maxlen }});" onkeyup="jchatCalculateMaxLen(this,'jchatWLen', {{ maxlen }});"></textarea>
						<div class="jchat_bottom_controls">
							<div class="jchat_emoji_picker">
								<button type="button" id="jchatEmojiBtn" class="jchat_emoji_btn" onclick="jchatToggleEmojiPanel(); return false;">😊</button>
								<div id="jchatEmojiPanel" class="jchat_emoji_panel">
									<div id="jchatEmojiGrid" class="jchat_emoji_grid"></div>
								</div>
							</div>
							<div class="jchat_char_count">
								<span id="jchatWLen">{{ maxlen }}</span>
								/
								{{ maxlen }}
							</div>
						</div>
						<input id="jChatSubmit" type="submit" value="{{ lang.jchat.button.post }}"/>
					</form>
				</div>
			{% endif %}
		</div>
		<!-- SCRIPTS INTERNALS BEGIN ((( DO NOT CHANGE ))) -->
		{% include 'plugins/jchat/jchat.script.footer.tpl' %}
		<!-- SCRIPTS INTERNALS END -->
	</body>
</html>
