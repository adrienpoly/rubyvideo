document.addEventListener('turbo:load', function () {
  const hamburger = document.getElementById('hamburger')
  if (hamburger) {
    hamburger.addEventListener('click', function () {
      const mobileMenu = document.getElementById('mobile-menu')
      const content = document.getElementById('main')
      const openIcon = document.getElementById('menu-open-icon')
      const closeIcon = document.getElementById('menu-close-icon')

      if (
        mobileMenu.style.display === 'none' ||
        mobileMenu.style.display === ''
      ) {
        mobileMenu.style.display = 'block'
        content.style.marginTop = '200px' // adjust the value as needed
        openIcon.style.display = 'none'
        closeIcon.style.display = 'block'
      } else {
        mobileMenu.style.display = 'none'
        content.style.marginTop = '0'
        openIcon.style.display = 'block'
        closeIcon.style.display = 'none'
      }
    })
  }
})
