/*window.onload = function(){
	var E = window.wangEditor;
    var editor = new E('#edit_tool');
	//创建编辑器
    editor.create();
}*/
$(function(){
   	var E = window.wangEditor;
    var editor = new E('#edit_tool');
	//创建编辑器
    editor.create();


    //点击div相当于触发文件上传框
	// $('#click_video').on("click",function(){
	// 	$("#load_video_one").trigger("click");
	// });

});
function loadFile(file){
    $("#filename").html(file.name);
}
function loadmusicFile(file){
    $("#filenameMusic").html(file.name);
}
function loadFileimg(file){
    $("#filenameImg").html( $("#filenameImg").text()+file.name);
}

function publishVideo(file){
    $("#filenameImg").html( $("#publishVideo").text()+file.name);
}
