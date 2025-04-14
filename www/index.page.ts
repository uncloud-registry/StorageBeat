import { parse } from 'jsr:@std/csv/parse'

export const title = 'StorageBeat'

export const layout = 'layout.vto'

const csvFile = await Deno.readTextFile('../data/storage.csv')
const data = parse(csvFile)
const headings = data.shift()!

export default function Layout({ title }: { title: string }) {
  return `<main>
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
    <script src="/js/sort.js"></script></main>
    `
}
