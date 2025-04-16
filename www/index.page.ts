import { parse } from 'jsr:@std/csv/parse'

export const layout = 'layout.vto'

const data = parse(await Deno.readTextFile('../data/storage.csv'))
const headings = data.shift()!

const references = parse(await Deno.readTextFile('../data/references.csv'))

export default function Layout() {
  return `<main>
   <div class="table">
 <table border="1" id="table">
        <thead>
            <tr>
                ${headings.map((heading) => `<th>${heading}</th>`).join('')}
            </tr>
        </thead>
        <tbody>
            ${
    data.map((row) =>
      `<tr>${row.map((value) => `<td>${value}</td>`).join('')}</tr>`
    ).join('')
  }
        </tbody>
    </table>
   </div>
     <ol>
    ${references.map((row) => `<li>${row.join(', ')}</li>`).join('')}
    </ol>
    <script src="/js/sort.js"></script></main>
    `
}
