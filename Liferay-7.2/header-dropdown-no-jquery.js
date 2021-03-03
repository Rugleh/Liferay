var elements = document.getElementsByClassName("lfr-nav-item nav-item dropdown");
var elem = elements[0];
for (let i = 0; i < elements.length; i++) {
    elements[i].onclick = function() {
        this.classList.toggle('hover');
        this.classList.toggle('open');
        var elem = elements[i];
        var siblings = getSiblings(elem);
        
    for (let j = 0; j < siblings.length; j++){
        siblings[j].classList.remove('hover')
        siblings[j].classList.remove('open')
    }
  };
}


var getSiblings = function (elem) {

	// Setup siblings array and get the first sibling
	var siblings = [];
	var sibling = elem.parentNode.firstChild;

	// Loop through each sibling and push to the array
	while (sibling) {
		if (sibling.nodeType === 1 && sibling !== elem) {
			siblings.push(sibling);
		}
		sibling = sibling.nextSibling
	}

	return siblings;

};
