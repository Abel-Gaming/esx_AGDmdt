$(function(){
	function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "vehicle-information") {
            document.getElementById("vehplate").innerHTML = item.plate;
        }
    })

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "vehicle-information-all") {
            document.getElementById("vehplate").innerHTML = item.plate;
            document.getElementById("vehname").innerHTML = item.name;
            document.getElementById("vehowner").innerHTML = item.owner;
            document.getElementById("vehownerjob").innerHTML = item.ownerjob;
            document.getElementById("vehwanted").innerHTML = item.wantedstatus;
        }
    })

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "person-information-all") {
            document.getElementById("personfirst").innerHTML = item.firstName;
            document.getElementById("personlast").innerHTML = item.lastName;
            document.getElementById("personjob").innerHTML = item.job;
            document.getElementById("persondob").innerHTML = item.dob;
            document.getElementById("personsex").innerHTML = item.sex;
            document.getElementById("personheight").innerHTML = item.height;
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://esx_AGDmdt/exit', JSON.stringify({}));
            return
        }
    };

    //Search Plate
    $("#submitplate").click(function () {
        let inputValue = $("#inputplate").val()
        if (!inputValue) {
            $.post("http://esx_AGDmdt/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://esx_AGDmdt/platesearch', JSON.stringify({
            text: inputValue,
        }));
        return;
    })

    //Search Name
    $("#submitname").click(function () {
        let firstname = $("#inputfirstname").val()
        let lastname = $("#inputlastname").val()
        if (!firstname) {
            $.post("http://esx_AGDmdt/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://esx_AGDmdt/namesearch', JSON.stringify({
            textfirst: firstname,
            textsecond: lastname,
        }));
        return;
    })
});

function openPage(pageName, elmnt, color) {
    // Hide all elements with class="tabcontent" by default */
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
  
    // Remove the background color of all tablinks/buttons
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].style.backgroundColor = "";
    }
  
    // Show the specific tab content
    document.getElementById(pageName).style.display = "block";
  
    // Add the specific color to the button used to open the tab content
    elmnt.style.backgroundColor = color;
  }
  
  // Get the element with id="defaultOpen" and click on it
  document.getElementById("defaultOpen").click();