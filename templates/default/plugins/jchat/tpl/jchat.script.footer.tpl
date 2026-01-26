<script language="javascript">
var CHATTER = new jChat({{ history }}, {{ refresh }}, 'jChatTable', {{ msgOrder }});
CHATTER.loadData({{ data|raw }});
CHATTER.timerStart();
</script>
