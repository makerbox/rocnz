// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function searchme(){
	var searchterm = $('#searchfield').val();
	window.location.href = "?searchterm="+searchterm;
};

function searchprod(){
	var searchterm = $('#searchfield').val();
	window.location.href = window.location.href+"&searchterm="+searchterm;
};



function removeMe(me){
	$(me).parent().css('display','none');
	qty = $(me).data('qty');
	price = $(me).data('price') * qty;
	totalqty = parseInt($('#totalqty').text(), 10);
	totalprice = parseFloat($('#totalprice').text()).toFixed(2);
	console.log(totalqty + ' x ' + totalprice);
	newqty = totalqty - qty;
	newprice = (totalprice - price).toFixed(2);
	$('#totalqty').html(newqty);
	$('#totalprice').html(newprice);
};