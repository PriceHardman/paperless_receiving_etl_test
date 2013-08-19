$(function(){
    $('#descriptions_list').click(function(e){
        $(this).find('ul.categories').toggleClass("visible");

    });

    $('li.category').click(function(e){
        $(this).find("ul.category_descriptions").toggleClass("visible");
        e.stopPropagation(); //keep this click event from also triggering a click event further up the DOM tree.

    });

    $('li.category_description a').click(function(e){
        e.stopPropagation();

    });

    description_search_listener();
});

function description_search_listener(){
    //listen for the user searching for a description
    //get descriptions with $('#descriptions_dropdown option')
    $('#pallet_description').keyup(function(e){
        $('#pallet_description').unbind("keyup");
        setTimeout(function(){
            var search_string = $('#pallet_description').val().toUpperCase(); //get search string and capitalize it
            if(search_string.length == 0){
                description_search_listener();
                return;
            }
            var search_results = $.grep($('#descriptions_dropdown option'),function(element,index){
                return ($(element).val().indexOf(search_string) > -1);
            });
            show_search_results(search_results);
            description_search_listener();
        },1000);
    });
};

function show_search_results(search_results){
    $.each(search_results,function(index,element){
        console.log(element.value);
    });
};