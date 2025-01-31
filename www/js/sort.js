const table = document.getElementById('table')

function sortTable(columnIndex, isNumeric = false, header) {
  const rows = Array.from(table.querySelectorAll('tbody tr'))

  rows.sort((a, b) => {
    const aValue = a.cells[columnIndex].textContent.trim()
    const bValue = b.cells[columnIndex].textContent.trim()

    if (isNumeric) {
      return parseFloat(aValue) - parseFloat(bValue)
    } else {
      return aValue.localeCompare(bValue)
    }
  })

  // Reverse the order if the column is already sorted
  if (table.dataset.sortedColumn === String(columnIndex)) {
    if (header.textContent.includes('▼')) {
      header.textContent = header.textContent.replace('▼', '▲')
    } else {
      header.textContent = `${header.textContent} ▲`
    }
    rows.reverse()
    table.dataset.sortedColumn = null
  } else {
    if (header.textContent.includes('▲')) {
      header.textContent = header.textContent.replace('▲', '▼')
    } else {
      header.textContent = `${header.textContent} ▼`
    }
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
    const isNumeric = index === 3
    sortTable(index, isNumeric, header)
  })
})
