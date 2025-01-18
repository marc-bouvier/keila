module.exports = {
  content: ["./js/**/*.js", "./css/**/*.*css", "../lib/*_web/**/*.*ex"],
  darkMode: 'selector', // or 'media' or 'selector'
  theme: {
    extend: {
      colors: {
        gray: {
          950: "#0F131A"
        }
      }
    }
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")]
}
