const table = document.getElementById('table')

function sortTable(columnIndex, header) {
  const rows = Array.from(table.querySelectorAll('tbody tr'))

  rows.sort((a, b) => {
    const aValue = a.cells[columnIndex].textContent.trim()
    const bValue = b.cells[columnIndex].textContent.trim()

    const isNumeric = parseFloat(aValue) !== NaN

    if (isNumeric) {
      return parseFloat(aValue) - parseFloat(bValue)
    } else {
      return aValue.localeCompare(bValue)
    }
  })

  table.querySelectorAll('th').forEach((th) => {
    const text = th.textContent
    if (text.endsWith(' ▲') || text.endsWith(' ▼')) {
      th.textContent = text.slice(0, -2) // Remove last 2 characters
    }
  })

  // Reverse the order if the column is already sorted
  if (table.dataset.sortedColumn === String(columnIndex)) {
    header.textContent = header.textContent.trim() + ' ▲'
    rows.reverse()
    table.dataset.sortedColumn = null
  } else {
    header.textContent = header.textContent.trim() + ' ▼'
    table.dataset.sortedColumn = columnIndex
  }

  // Update the table with sorted rows
  const tbody = table.querySelector('tbody')
  tbody.innerHTML = ''
  rows.forEach((row) => tbody.appendChild(row))
}

// Add click event listeners to table headers
table.querySelectorAll('th').forEach((header, index) => {
  header.addEventListener('click', () => {
    sortTable(index, header)
  })
})
