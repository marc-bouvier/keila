/**
* Switches theme.
* @see https://tailwindcss.com/docs/dark-mode#supporting-system-preference-and-manual-selection
* @param {"dark"|"light"|"system"} mode 
*/
export const switch_theme = (mode) => {
    if(mode==='dark') {
        localStorage.theme = 'dark'
    }
    if(mode==='light') {
        localStorage.theme = 'light' 
    }
    if(mode==='system') {
      localStorage.removeItem('theme')
    }
    // relies on function apply_theme() defined inline in head in HTML root (explained there)
    window.apply_theme()
} 

export const ThemeSwitch = {

  mounted() {
    window.apply_theme()
  }

}
