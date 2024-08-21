const avatar = () => {
	let avatar = document.querySelector("header nav a:nth-child(3)")
	
	if (avatar.className == "up") avatar.classList.remove("up")
	else if (Math.random() > 0.95) avatar.className = "up" }

export default avatar