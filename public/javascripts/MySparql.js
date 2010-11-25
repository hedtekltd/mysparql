var create_table = function(data) {
      var table = "<table><tr>"
      var order = []
      $.each(data.variables, function(index, variable_name) {
        table += "<th>" + variable_name + "</th>"
        order.push(variable_name)
      });
      table += "</tr>"
      $.each(data.results, function(index, result) {
        table += "<tr>"
        $.each(order, function(index, binding) {
          table += "<td>" + result[binding] +"</td>"
        });
        table += "</tr>"
      });
      table += "</table>"
      return table;
};

var table_formatter = function(query, data) {
      $(query).replaceWith(create_table(data));
    };

var submit_tutorial_box = function(event, query_id) {
  var url = mysparql_path + '/queries/run'
  var success_func = function(data) {
    $("#" + query_id + " .results").html(create_table(data))
  };
  $.ajax({type : "POST", data : event.serialize(), dataType : "json", success : success_func, url : url});
  return false;
};

var tutorial_formatter = function(query, data) {
  var query_id = $(query).attr("href")
  var form = '<form id="' + query_id + '" method="post" onsubmit="return submit_tutorial_box($(this), \'' + query_id + '\');">'
  form += '<label for="query">Query</label><br/>'
  form += '<textarea name="query">'+data["query"]["query"]+'</textarea><br/>'
  form += '<input type="hidden" name="query_id" value="' + query_id + '" />'
  form += '<input type="submit" value="Run Query" /><br/>'
  form += 'Results<br/>'
  form += '<div class="results"></div>'
  form += '</form>'
  $(query).replaceWith(form)
};

$(document).ready(function() {
  $(".mysparql").each(function(index, query) {
    var query_id = $(query).attr("href")
    var query_type = $(query).attr("data-formatter")
    var formatter;
    var url;

    //Determine which formatter to use and set that formatter up
    switch (query_type) {
      case "tutorial":
        formatter = tutorial_formatter;
        url = mysparql_path + "/queries/" + query_id + "?tutorial"
        break;
      case "table":
        formatter = table_formatter;
        url = mysparql_path + "/queries/" + query_id
        break;
      default:
        formatter = table_formatter;
        url = mysparql_path + "/queries/" + query_id
        break;
    };

    //Construct the success callback.
    var success_func = function(data) {
      formatter(query, data);
    };

    //Set up the mysparql link to indicate status and to deactivate clicking the link
    $(query).html("Loading...")
    $(query).click(function() {return false;});
    $.get(url, success_func, "json");  
  });
});

