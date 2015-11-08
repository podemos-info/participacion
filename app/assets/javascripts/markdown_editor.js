
var toolbar_markdown_editor =  [{
		name: "bold",
		action: SimpleMDE.toggleBold,
		className: "fa fa-bold",
		title: "Negrita (Ctrl+B)"
	}, {
		name: "italic",
		action: SimpleMDE.toggleItalic,
		className: "fa fa-italic",
		title: "Cursiva (Ctrl+I)"
	}, {
		name: "strikethrough",
		action: SimpleMDE.toggleStrikethrough,
		className: "fa fa-strikethrough",
		title: "Tachado"
	}, {
		name: "heading",
		action: SimpleMDE.toggleHeadingSmaller,
		className: "fa fa-header",
		title: "Encabezado (Ctrl+H)"
	}, {
		name: "unordered-list",
		action: SimpleMDE.toggleUnorderedList,
		className: "fa fa-list-ul",
		title: "Lista (Ctrl+L)"
	}, {
		name: "ordered-list",
		action: SimpleMDE.toggleOrderedList,
		className: "fa fa-list-ol",
		title: "Lista numerada (Ctrl+Alt+L)"
	}, 
    "|",
    {
		name: "preview",
		action: SimpleMDE.togglePreview,
		className: "fa fa-eye no-disable",
		title: "Previsualizar (Ctrl+P)"
	}, {
		name: "side-by-side",
		action: SimpleMDE.toggleSideBySide,
		className: "fa fa-columns no-disable no-mobile",
		title: "Vista a 2 columnas (F9)"
	}, {
		name: "fullscreen",
		action: SimpleMDE.toggleFullScreen,
		className: "fa fa-arrows-alt no-disable no-mobile",
		title: "Vista a pantalla completa (F11)"
	}
];

var markdown_editors = [];

$(function() {
	$('textarea.markdown-editor').each(function(el) {
		markdown_editors.push(new SimpleMDE({element: el, toolbar: toolbar_markdown_editor}));
	});
});

/*
	{
		name: "heading-smaller",
		action: toggleHeadingSmaller,
		className: "fa fa-header fa-header-x fa-header-smaller",
		title: "Smaller Heading (Ctrl+H)"
	}, {
		name: "heading-bigger",
		action: toggleHeadingBigger,
		className: "fa fa-header fa-header-x fa-header-bigger",
		title: "Bigger Heading (Shift+Ctrl+H)"
	}, {
		name: "heading-1",
		action: toggleHeading1,
		className: "fa fa-header fa-header-x fa-header-1",
		title: "Big Heading"
	}, {
		name: "heading-2",
		action: toggleHeading2,
		className: "fa fa-header fa-header-x fa-header-2",
		title: "Medium Heading"
	}, {
		name: "heading-3",
		action: toggleHeading3,
		className: "fa fa-header fa-header-x fa-header-3",
		title: "Small Heading"
	}, {
		name: "code",
		action: toggleCodeBlock,
		className: "fa fa-code",
		title: "Código (Ctrl+Alt+C)"
	}, {
		name: "quote",
		action: toggleBlockquote,
		className: "fa fa-quote-left",
		title: "Citar (Ctrl+')"
	}, {
		name: "link",
		action: drawLink,
		className: "fa fa-link",
		title: "Crear enlace (Ctrl+K)"
	}, {
		name: "image",
		action: drawImage,
		className: "fa fa-picture-o",
		title: "Insertar Imágen (Ctrl+Alt+I)"
	}, {
		name: "horizontal-rule",
		action: drawHorizontalRule,
		className: "fa fa-minus",
		title: "Insertar línea horizontal"
	}, {
		name: "guide",
		action: "https://plaza.podemos.info/guia-markdown",
		className: "fa fa-question-circle",
		title: "Guia Markdown"
	}
*/
