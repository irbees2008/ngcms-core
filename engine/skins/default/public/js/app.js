(window.webpackJsonp=window.webpackJsonp||[]).push([[2],{2:function(e,t,n){e.exports=n("ng4s")},YvjZ:function(e,t){function n(e){return(n="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}!function(e){var t={init:function(i){return this.each((function(){var o=e(this);o.data("uploadifive",{inputs:{},inputCount:0,fileID:0,queue:{count:0,selected:0,replaced:0,errors:0,queued:0,cancelled:0},uploads:{current:0,attempts:0,successful:0,errors:0,count:0}});var r,a=o.data("uploadifive"),u=a.settings=e.extend({auto:!0,buttonClass:!1,buttonText:"Select Files",checkScript:!1,dnd:!0,dropTarget:!1,fileObjName:"Filedata",fileSizeLimit:0,fileType:!1,formData:{},height:30,itemTemplate:!1,method:"post",multi:!0,overrideEvents:[],queueID:!1,queueSizeLimit:0,removeCompleted:!1,simUploadLimit:0,truncateLength:0,uploadLimit:0,uploadScript:"uploadifive.php",width:100},i);if(u.fileType&&(r=u.fileType.split("|")),isNaN(u.fileSizeLimit)){var l=1.024*parseInt(u.fileSizeLimit);u.fileSizeLimit.indexOf("KB")>-1?u.fileSizeLimit=1e3*l:u.fileSizeLimit.indexOf("MB")>-1?u.fileSizeLimit=1e6*l:u.fileSizeLimit.indexOf("GB")>-1&&(u.fileSizeLimit=1e9*l)}else u.fileSizeLimit=1024*u.fileSizeLimit;if(a.inputTemplate=e('<input type="file">').css({"font-size":u.height+"px",opacity:0,position:"absolute",right:"-3px",top:"-3px","z-index":999}),a.createInput=function(){var n=a.inputTemplate.clone(),i=n.name="input"+a.inputCount++;u.multi&&n.attr("multiple",!0),u.fileType&&n.attr("accept",u.fileType),n.bind("change",(function(){a.queue.selected=0,a.queue.replaced=0,a.queue.errors=0,a.queue.queued=0;var n=this.files.length;if(a.queue.selected=n,a.queue.count+n>u.queueSizeLimit&&0!==u.queueSizeLimit)e.inArray("onError",u.overrideEvents)<0&&alert("The maximum number of queue items has been reached ("+u.queueSizeLimit+").  Please select fewer files."),"function"==typeof u.onError&&u.onError.call(o,"QUEUE_LIMIT_EXCEEDED");else{for(var r=0;r<n;r++)file=this.files[r],a.addQueueItem(file);a.inputs[i]=this,a.createInput()}u.auto&&t.upload.call(o),"function"==typeof u.onSelect&&u.onSelect.call(o,a.queue)})),a.currentInput&&a.currentInput.hide(),a.button.append(n),a.currentInput=n},a.destroyInput=function(t){e(a.inputs[t]).remove(),delete a.inputs[t],a.inputCount--},a.drop=function(n){n.preventDefault(),n.stopPropagation(),a.queue.selected=0,a.queue.replaced=0,a.queue.errors=0,a.queue.queued=0;var i=n.dataTransfer,l=i.name="input"+a.inputCount++,s=i.files.length;if(a.queue.selected=s,a.queue.count+s>u.queueSizeLimit&&0!==u.queueSizeLimit)e.inArray("onError",u.overrideEvents)<0&&alert("The maximum number of queue items has been reached ("+u.queueSizeLimit+").  Please select fewer files."),"function"==typeof u.onError&&u.onError.call(o,"QUEUE_LIMIT_EXCEEDED");else{for(var c=0;c<s;c++)file=i.files[c],a.addQueueItem(file),r&&-1===r.indexOf(file.type)&&a.error("FORBIDDEN_FILE_TYPE",file);a.inputs[l]=i}u.auto&&t.upload.call(o),"function"==typeof u.onDrop&&u.onDrop.call(o,i.files,i.files.length)},a.fileExistsInQueue=function(e){for(var t in a.inputs){input=a.inputs[t],limit=input.files.length;for(var n=0;n<limit;n++)if(existingFile=input.files[n],existingFile.name==e.name&&!existingFile.complete)return!0}return!1},a.removeExistingFile=function(e){for(var n in a.inputs){input=a.inputs[n],limit=input.files.length;for(var i=0;i<limit;i++)existingFile=input.files[i],existingFile.name!=e.name||existingFile.complete||(a.queue.replaced++,t.cancel.call(o,existingFile,!0))}},!1===u.itemTemplate?a.queueItem=e('<div class="uploadifive-queue-item"><a class="close" href="#">×</a><div><span class="filename"></span><span class="fileinfo"></span></div><div class="progress"><div class="progress-bar"></div></div></div>'):a.queueItem=e(u.itemTemplate),a.addQueueItem=function(n){if(e.inArray("onAddQueueItem",u.overrideEvents)<0){a.removeExistingFile(n),n.queueItem=a.queueItem.clone(),n.queueItem.attr("id",u.id+"-file-"+a.fileID++),n.queueItem.find(".close").bind("click",(function(){return t.cancel.call(o,n),!1}));var i=n.name;i.length>u.truncateLength&&0!==u.truncateLength&&(i=i.substring(0,u.truncateLength)+"..."),n.queueItem.find(".filename").html(i),n.queueItem.data("file",n),a.queueEl.append(n.queueItem)}"function"==typeof u.onAddQueueItem&&u.onAddQueueItem.call(o,n),n.size>u.fileSizeLimit&&0!==u.fileSizeLimit?a.error("FILE_SIZE_LIMIT_EXCEEDED",n):(a.queue.queued++,a.queue.count++)},a.removeQueueItem=function(t,n,i){i||(i=0);var o=n?0:500;t.queueItem&&(" - Completed"!=t.queueItem.find(".fileinfo").html()&&t.queueItem.find(".fileinfo").html(" - Cancelled"),t.queueItem.find(".progress-bar").width(0),t.queueItem.delay(i).fadeOut(o,(function(){e(this).remove()})),delete t.queueItem,a.queue.count--)},a.filesToUpload=function(){var e=0;for(var t in a.inputs){input=a.inputs[t],limit=input.files.length;for(var n=0;n<limit;n++)file=input.files[n],file.skip||file.complete||e++}return e},a.checkExists=function(n){if(e.inArray("onCheck",u.overrideEvents)<0){e.ajaxSetup({async:!1});var i=e.extend(u.formData,{filename:n.name});if(e.post(u.checkScript,i,(function(e){n.exists=parseInt(e)})),n.exists&&!confirm("A file named "+n.name+" already exists in the upload folder.\nWould you like to replace it?"))return t.cancel.call(o,n),!0}return"function"==typeof u.onCheck&&u.onCheck.call(o,n,n.exists),!1},a.uploadFile=function(t,i){if(!t.skip&&!t.complete&&!t.uploading)if(t.uploading=!0,a.uploads.current++,a.uploads.attempted++,xhr=t.xhr=new XMLHttpRequest,"function"==typeof FormData||"object"===("undefined"==typeof FormData?"undefined":n(FormData))){var r=new FormData;for(var l in r.append(u.fileObjName,t),u.formData)r.append(l,u.formData[l]);xhr.open(u.method,u.uploadScript,!0),xhr.upload.addEventListener("progress",(function(e){e.lengthComputable&&a.progress(e,t)}),!1),xhr.addEventListener("load",(function(e){4==this.readyState&&(t.uploading=!1,200==this.status?"Invalid file type."!==t.xhr.responseText?a.uploadComplete(e,t,i):a.error(t.xhr.responseText,t,i):404==this.status?a.error("404_FILE_NOT_FOUND",t,i):403==this.status?a.error("403_FORBIDDEN",t,i):a.error("Unknown Error",t,i))})),xhr.send(r)}else{var s=new FileReader;s.onload=function(n){var r="-------------------------"+(new Date).getTime(),l="\r\n",s="";for(var c in s+="--"+r+l,s+='Content-Disposition: form-data; name="'+u.fileObjName+'"',t.name&&(s+='; filename="'+t.name+'"'),s+=l,s+="Content-Type: application/octet-stream\r\n\r\n",s+=n.target.result+l,u.formData)s+="--"+r+l,s+='Content-Disposition: form-data; name="'+c+'"'+l+l,s+=u.formData[c]+l;s+="--"+r+"--"+l,xhr.upload.addEventListener("progress",(function(e){a.progress(e,t)}),!1),xhr.addEventListener("load",(function(e){t.uploading=!1,404==this.status?a.error("404_FILE_NOT_FOUND",t,i):"Invalid file type."!=t.xhr.responseText?a.uploadComplete(e,t,i):a.error(t.xhr.responseText,t,i)}),!1);u.uploadScript;"get"==u.method&&e(u.formData).param();xhr.open(u.method,u.uploadScript,!0),xhr.setRequestHeader("Content-Type","multipart/form-data; boundary="+r),"function"==typeof u.onUploadFile&&u.onUploadFile.call(o,t),xhr.sendAsBinary(s)},s.readAsBinaryString(t)}},a.progress=function(t,n){var i;e.inArray("onProgress",u.overrideEvents)<0&&(t.lengthComputable&&(i=Math.round(t.loaded/t.total*100)),n.queueItem.find(".fileinfo").html(" - "+i+"%"),n.queueItem.find(".progress-bar").css("width",i+"%")),"function"==typeof u.onProgress&&u.onProgress.call(o,n,t)},a.error=function(n,i,r){if(e.inArray("onError",u.overrideEvents)<0){switch(n){case"404_FILE_NOT_FOUND":errorMsg="404 Error";break;case"403_FORBIDDEN":errorMsg="403 Forbidden";break;case"FORBIDDEN_FILE_TYPE":errorMsg="Forbidden File Type";break;case"FILE_SIZE_LIMIT_EXCEEDED":errorMsg="File Too Large";break;default:errorMsg="Unknown Error"}i.queueItem.addClass("error").find(".fileinfo").html(" - "+errorMsg),i.queueItem.find(".progress").remove()}"function"==typeof u.onError&&u.onError.call(o,n,i),i.skip=!0,"404_FILE_NOT_FOUND"==n?a.uploads.errors++:a.queue.errors++,r&&t.upload.call(o,null,!0)},a.uploadComplete=function(n,i,r){e.inArray("onUploadComplete",u.overrideEvents)<0&&(i.queueItem.find(".progress-bar").css("width","100%"),i.queueItem.find(".fileinfo").html(" - Completed"),i.queueItem.find(".progress").slideUp(250),i.queueItem.addClass("complete")),"function"==typeof u.onUploadComplete&&u.onUploadComplete.call(o,i,i.xhr.responseText),u.removeCompleted&&setTimeout((function(){t.cancel.call(o,i)}),3e3),i.complete=!0,a.uploads.successful++,a.uploads.count++,a.uploads.current--,delete i.xhr,r&&t.upload.call(o,null,!0)},a.queueComplete=function(){"function"==typeof u.onQueueComplete&&u.onQueueComplete.call(o,a.uploads)},!(window.File&&window.FileList&&window.Blob&&(window.FileReader||window.FormData)))return"function"==typeof u.onFallback&&u.onFallback.call(o),!1;if(u.id="uploadifive-"+o.attr("id"),a.button=e('<div id="'+u.id+'" class="uploadifive-button">'+u.buttonText+"</div>"),u.buttonClass&&a.button.addClass(u.buttonClass),a.button.css({height:u.height,"line-height":u.height+"px",overflow:"hidden",position:"relative","text-align":"center",width:u.width}),o.before(a.button).appendTo(a.button).hide(),a.createInput.call(o),u.queueID?a.queueEl=e("#"+u.queueID):(u.queueID=u.id+"-queue",a.queueEl=e('<div id="'+u.queueID+'" class="uploadifive-queue" />'),a.button.after(a.queueEl)),u.dnd){var s=u.dropTarget?e(u.dropTarget):a.queueEl.get(0);s.addEventListener("dragleave",(function(e){e.preventDefault(),e.stopPropagation()}),!1),s.addEventListener("dragenter",(function(e){e.preventDefault(),e.stopPropagation()}),!1),s.addEventListener("dragover",(function(e){e.preventDefault(),e.stopPropagation()}),!1),s.addEventListener("drop",a.drop,!1)}XMLHttpRequest.prototype.sendAsBinary||(XMLHttpRequest.prototype.sendAsBinary=function(e){var t=Array.prototype.map.call(e,(function(e){return 255&e.charCodeAt(0)})),n=new Uint8Array(t);this.send(n.buffer)}),"function"==typeof u.onInit&&u.onInit.call(o)}))},debug:function(){return this.each((function(){console.log(e(this).data("uploadifive"))}))},clearQueue:function(){this.each((function(){var n=e(this),o=n.data("uploadifive"),r=o.settings;for(var a in o.inputs)for(input=o.inputs[a],limit=input.files.length,i=0;i<limit;i++)file=input.files[i],t.cancel.call(n,file);"function"==typeof r.onClearQueue&&r.onClearQueue.call(n,e("#"+o.settings.queueID))}))},cancel:function(n,i){this.each((function(){var o=e(this),r=o.data("uploadifive"),a=r.settings;"string"==typeof n&&(isNaN(n)||(fileID="uploadifive-"+e(this).attr("id")+"-file-"+n),n=e("#"+fileID).data("file")),n.skip=!0,r.filesCancelled++,n.uploading&&(r.uploads.current--,n.uploading=!1,n.xhr.abort(),delete n.xhr,t.upload.call(o)),e.inArray("onCancel",a.overrideEvents)<0&&r.removeQueueItem(n,i),"function"==typeof a.onCancel&&a.onCancel.call(o,n)}))},upload:function(t,n){this.each((function(){var i=e(this),o=i.data("uploadifive"),r=o.settings;if(t)o.uploadFile.call(i,t);else if(o.uploads.count+o.uploads.current<r.uploadLimit||0===r.uploadLimit){if(!n){o.uploads.attempted=0,o.uploads.successsful=0,o.uploads.errors=0;var a=o.filesToUpload();"function"==typeof r.onUpload&&r.onUpload.call(i,a)}e("#"+r.queueID).find(".uploadifive-queue-item").not(".error, .complete").each((function(){if(_file=e(this).data("file"),o.uploads.current>=r.simUploadLimit&&0!==r.simUploadLimit||o.uploads.current>=r.uploadLimit&&0!==r.uploadLimit||o.uploads.count>=r.uploadLimit&&0!==r.uploadLimit)return!1;r.checkScript?(_file.checking=!0,skipFile=o.checkExists(_file),_file.checking=!1,skipFile||o.uploadFile(_file,!0)):o.uploadFile(_file,!0)})),0===e("#"+r.queueID).find(".uploadifive-queue-item").not(".error, .complete").size()&&o.queueComplete()}else 0===o.uploads.current&&(e.inArray("onError",r.overrideEvents)<0&&o.filesToUpload()>0&&0!==r.uploadLimit&&alert("The maximum upload limit has been reached."),"function"==typeof r.onError&&r.onError.call(i,"UPLOAD_LIMIT_EXCEEDED",o.filesToUpload()))}))},destroy:function(){this.each((function(){var n=e(this),i=n.data("uploadifive"),o=i.settings;t.clearQueue.call(n),o.queueID||e("#"+o.queueID).remove(),n.siblings("input").remove(),n.show().insertBefore(i.button),i.button.remove(),"function"==typeof o.onDestroy&&o.onDestroy.call(n)}))}};e.fn.uploadifive=function(i){return t[i]?t[i].apply(this,Array.prototype.slice.call(arguments,1)):"object"!==n(i)&&i?void e.error("The method "+i+" does not exist in $.uploadify"):t.init.apply(this,arguments)}}(jQuery)},daJz:function(e,t,n){"use strict";n.r(t);var i={};function o(e){return function(e){if(Array.isArray(e))return r(e)}(e)||function(e){if("undefined"!=typeof Symbol&&Symbol.iterator in Object(e))return Array.from(e)}(e)||function(e,t){if(!e)return;if("string"==typeof e)return r(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);"Object"===n&&e.constructor&&(n=e.constructor.name);if("Map"===n||"Set"===n)return Array.from(e);if("Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n))return r(e,t)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function r(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,i=new Array(t);n<t;n++)i[n]=e[n];return i}function a(e){return JSON.stringify(e)}function u(){var e=($(window).width()-$("#loading-layer").width())/2,t=($(window).height()-$("#loading-layer").height())/2;$("#loading-layer").css({left:e+"px",top:t+"px"}).fadeIn(0)}function l(){$("#loading-layer").fadeOut("slow")}function s(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};t=$.extend({time:5e3,speed:"slow",className:"alert-info",sticked:!1,closeBTN:!1,position:{top:0,right:0}},t),$("#ng-stickers").length||$("body").prepend('<div id="ng-stickers"></div>');var n=$("#ng-stickers");n.css("position","fixed").css({right:"auto",left:"auto",top:"auto",bottom:"auto"}).css(t.position);var i=$('<div class="alert alert-dismissible fade"></div>').html(e);if(n.append(i),t.className&&i.addClass(t.className),t.sticked||t.closeBTN){var o=$('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>');i.prepend(o)}t.sticked||setTimeout((function(){i.alert("close")}),t.time),i.addClass("show")}function c(e,t){confirm(t)&&(document.location=e)}function d(e,t){document.cookie=e+"="+t+'; path="/"; expires=Thu, 1 Jan 2030 00:00:00 GMT;'}function p(e){document.cookie=e+"=; path=/; expires=Sut, 1 Jan 2000 00:00:01 GMT;"}function f(e){var t=" "+document.cookie,n=" "+e+"=",i=null,o=0,r=0;return t.length>0&&-1!=(o=t.indexOf(n))&&(o+=n.length,-1==(r=t.indexOf(";",o))&&(r=t.length),i=unescape(t.substring(o,r))),i}function m(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:"";o(e.elements).map((function(n){"checkbox"!=n.type||"master_box"==n.name||0!=t.length&&n.name.substr(0,t.length)!=t||(n.checked=!!e.master_box.checked)}))}function h(e,t,n){window.event.preventDefault();var i=document.getElementById(n||"content");if(document.selection&&document.selection.createRange)i.focus(),sel=document.selection.createRange(),sel.text=e+sel.text+t;else if(i.selectionStart||"0"==i.selectionStart){var o=i.selectionStart,r=i.selectionEnd,a=i.scrollTop;i.value=i.value.substring(0,o)+e+i.value.substring(o,r)+t+i.value.substring(r,i.value.length),i.selectionStart=i.selectionEnd=r+e.length+t.length,i.scrollTop=a}else i.value+=e+t;i.focus()}function g(e,t){var n=window.opener;n.document.forms.form;try{var i=n.document.forms.DATA_tmp_storage.area.value;""!=i&&(t=i)}catch(e){}var o=n.document.getElementById(t);if(o.focus(),n.selection&&n.selection.createRange)sel=n.selection.createRange(),sel.text=e=sel.text;else if(o.selectionStart||"0"==o.selectionStart){var r=o.selectionStart;o.selectionEnd;o.value=o.value.substring(0,r)+e+o.value.substring(r,o.value.length)}else o.value+=e;o.focus()}function v(e,t){this.message=e,this.response=t,this.name="AJAX Response Exception",this.toString=function(){return"".concat(this.name,": ").concat(this.message)}}function y(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{},n=!(arguments.length>2&&void 0!==arguments[2])||arguments[2],i=$('input[name="token"]').val();return $.ajax({method:"POST",url:NGCMS.admin_url+"/rpc.php",dataType:"json",headers:{"X-CSRF-TOKEN":i,"X-Requested-With":"XMLHttpRequest"},data:{json:1,token:i,methodName:e,params:JSON.stringify(t)},beforeSend:function(){u()}}).then((function(e){if(!e.status)throw new v("Error [".concat(e.errorCode,"]: ").concat(e.errorText),e);return e})).done((function(e){return n&&s(e.errorText,{className:"alert-success",closeBTN:!0}),e})).fail((function(e){s(e.message||NGCMS.lang.rpc_httpError,{className:"alert-danger",closeBTN:!0})})).always((function(){l()}))}n.r(i),n.d(i,"json_encode",(function(){return a})),n.d(i,"ngShowLoading",(function(){return u})),n.d(i,"ngHideLoading",(function(){return l})),n.d(i,"ngNotifySticker",(function(){return s})),n.d(i,"confirmit",(function(){return c})),n.d(i,"setCookie",(function(){return d})),n.d(i,"deleteCookie",(function(){return p})),n.d(i,"getCookie",(function(){return f})),n.d(i,"check_uncheck_all",(function(){return m})),n.d(i,"insertext",(function(){return h})),n.d(i,"insertimage",(function(){return g})),n.d(i,"post",(function(){return y}));try{for(var E in window.$=window.jQuery=n("EVdn"),window.Popper=n("8L3F").default,n("SYky"),n("5oTz"),n("YvjZ"),i)window[E]=i[E]}catch(e){console.error(e.message)}jQuery.fn.extend({size:function(){return this.length}}),$(document).ready((function(){$('input[name="token"]')||console.info("CSRF token not found"),$.datetimepicker.setLocale(NGCMS.langcode)}))},ng4s:function(e,t,n){"use strict";n("daJz");var i=JSON.parse(localStorage.getItem("collapseState"))||[],o=["#sidebarMenu","#collapseEditPreview"];$(document).ready((function(){$("#cdate").datetimepicker({format:"d.m.Y H:i"}),$('[data-toggle="collapse"]').each((function(e,t){var n=$(t).attr("data-target");n&&!o.includes(n)&&($(n).collapse({toggle:i.includes(n)}),$(n).on("shown.bs.collapse",(function(e){i.includes(n)||(i.push(n),localStorage.setItem("collapseState",JSON.stringify(i)))})),$(n).on("hidden.bs.collapse",(function(e){var t=i.findIndex((function(e){return e===n}));i.splice(t,1),localStorage.setItem("collapseState",JSON.stringify(i))})))})),$('[data-toggle="admin-group"]').on("click",(function(e){e.preventDefault();var t=$(this).parent().next();t.length&&$(t).hasClass("admin-group-content")&&$(t).toggle()}))}))},yLpj:function(e,t){var n;n=function(){return this}();try{n=n||new Function("return this")()}catch(e){"object"==typeof window&&(n=window)}e.exports=n}},[[2,0,1]]]);