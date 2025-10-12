// Profile dropdown functionality (only if user is logged in)

const profileTrigger = document.querySelector('.profile-trigger');
const profileDropdown = document.querySelector('.profile-dropdown');
const accountContainer = document.querySelector('.account-container');

if (profileTrigger && profileDropdown && accountContainer) {
	// Toggle dropdown on click
	profileTrigger.addEventListener('click', function(e) {
		e.stopPropagation();
		const isVisible = profileDropdown.style.opacity === '1';

		if (isVisible) {
			profileDropdown.style.opacity = '0';
			profileDropdown.style.visibility = 'hidden';
			profileDropdown.style.transform = 'translateY(-10px)';
		} else {
			profileDropdown.style.opacity = '1';
			profileDropdown.style.visibility = 'visible';
			profileDropdown.style.transform = 'translateY(0)';
		}
	});

	// Close dropdown when clicking outside
	document.addEventListener('click', function(e) {
		if (!accountContainer.contains(e.target)) {
			profileDropdown.style.opacity = '0';
			profileDropdown.style.visibility = 'hidden';
			profileDropdown.style.transform = 'translateY(-10px)';
		}
	});

	// Handle dropdown item clicks
	const dropdownItems = document.querySelectorAll('.dropdown-item');
	dropdownItems.forEach(item => {
		item.addEventListener('click', function() {
			const text = this.querySelector('span:last-child').textContent;

			// Handle different actions
			if (text === 'Your Orders') {
				window.location.href = `${contextPath}/orders`;
			} else if (text === 'Manage Account') {
				window.location.href = `${contextPath}/profile.jsp`;
			} else if (text === 'Submitted Reports') {
				window.location.href = `${contextPath}/reports`
			} else if (text === 'Logout') {
				if (confirm('Are you sure you want to logout?')) {
					window.location.href = `${contextPath}/user/logout`;
				}
			}

			// Close dropdown after action
			profileDropdown.style.opacity = '0';
			profileDropdown.style.visibility = 'hidden';
			profileDropdown.style.transform = 'translateY(-10px)';
		});
	});
}