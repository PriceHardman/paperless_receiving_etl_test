$(function(){
    var BACKSPACE = 8;
    var SPACE = 32;
    var DELETE = 46;

    function search_listener(){
        //when the user types something (i.e. on keyup),
        // unbind the keyup event so further typing doesn't interfere with
        // the handling of the typing event. Then set the following function
        // on a one second timeout:
        //      -submit an ajax get request to /freight_receipts with the input data as params[:search]
        //      -call search_listener(). The reason for this recursive calling is that this will
        //       rebind keyup and repeat the entire procedure, allowing for ajax requests every 2 seconds
        //       until the user stops typing.
        $('#search').keyup(function(e){
            $('#search').unbind("keyup");
            setTimeout(function(){
                submit_search();
                search_listener();
            },1000);
        });
    };

    function submit_search(){
        $.ajax({
            url: "/freight_receipts.json",
            data: {search: $('#search').val()},
            success: function(data){
                show_search_results(data);
            },
            error: function() {

            }
        });
    };

    function show_search_results(data){
        //On success, make the search_results div visible, size it properly, and fill it with data.
        $('#search_results tbody').html(""); //delete previous data.
        $('#search_results').hide(); //hide results.

        if(data.length > 0 || data == undefined ){
            $(data).each(function(index,element){
                //make a row containing fr#, booking#, sailing (vessel+voyage), dest_code, customer, consignee, shipper,
                // and fr timestamp (creation_date+create_time)
                var row_parity = index%2;
                if(row_parity==0){
                    var row = "<tr class=\"even_search\">";
                }
                else {
                    var row = "<tr class=\"odd_search\">";
                }

                row+="<td><a href=\"/freight_receipts/"+element.id+"\">"+element.id+"</a></td>"

                $([element.booking_id,element.vessel_id+element.voyage,element.dock_abbr,
                    element.customer,element.consignee,element.shipper,
                    element.creation_date+"  "+element.create_time]).each(function(index,element){

                        row+="<td>"+element+"</td>";

                    });

                row+="</tr>";
                $('#results_table tbody').append(row);
            });
            $('#search_results').show();
        }
        else {
            // don't do anything
        }

        //Make it so that clicking anywhere on a table row will trigger the link in the row's FR# field:
        $('#results_table tr,#').click(function(){
            var href = $(this).find("a").attr("href");
            if(href){
                window.location = href;
            }
        });
    };

    search_listener();

    $('.pallets').click(function(e){
        $(this).find('ul').toggleClass("visible");
        return false;
    });

});