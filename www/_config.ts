import lume from 'lume/mod.ts'
import google_fonts from 'lume/plugins/google_fonts.ts'
import katex from 'lume/plugins/katex.ts'

const site = lume()

site.use(google_fonts({
  fonts:
    'https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300..900;1,300..900&display=swap',
  subsets: ['latin'],
}))
site.use(katex())

site.copy('/styles/style.css')
site.copy('/js/sort.js')

export default site
