// ==UserScript==
// @name         Course Forum Backlog
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @include      https://discourse.cse.unsw.edu.au/20t3/comp1511/latest
// @grant        none
// ==/UserScript==

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

(function() {
    'use strict';

    if (document.readyState == "complete" || document.readyState == "loaded" || document.readyState == "interactive") {
        // backlog stats
        window.scrollTo(0,document.body.scrollHeight);
        const loadContainer = $('.loading-container')
        sleep(500).then(()=>{
            scrollTo(0,0);
        })

        let navBar = $('#navigation-bar')
        navBar.append($('<li><h4>Stats</h4><p id="backlog-len">backlog length loading...</p></li>'))
        let updateBacklogStats = () => {
            let lenBacklog = Array.from(document.getElementsByClassName('posters')).reduce((acc,i) => (i.childElementCount == 1) ? acc + 1 : acc , 0);
            console.log(`lenth is ${lenBacklog}`);
            let backlogMsg = '';
            if (lenBacklog == 0) {
                backlogMsg = 'Backlog is clear! 🎉';
            } else if (lenBacklog < 6) {
                backlogMsg = `Backlog length: ${lenBacklog} 😎`;
            } else if (lenBacklog < 11) {
                backlogMsg = `Backlog length: ${lenBacklog} 😅`;
            } else if (lenBacklog < 21) {
                backlogMsg = `Backlog length: ${lenBacklog} 😟`;
            } else if (lenBacklog < 31) {
                backlogMsg = `Backlog length: ${lenBacklog} 😢`;
            } else {
                backlogMsg = `Backlog length: ${lenBacklog} 😱`;
            }
            $('#backlog-len').html(backlogMsg);

        };
        // kick it off and schedule regularly
        window.setInterval(updateBacklogStats, 3000);



    } else {
            document.addEventListener("DOMContentLoaded", function(event) {
                alert("Just Loaded");
            });
        }
    // Your code here...
})();
