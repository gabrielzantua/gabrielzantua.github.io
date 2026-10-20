(() => {
  const list = document.getElementById('post-list');
  const select = document.getElementById('note-sort');
  const menu = document.getElementById('sort-menu');
  if (!list || !select || !menu) return;

  document.getElementById('note-sort-control').hidden = false;
  menu.addEventListener('click', (event) => {
    const option = event.target.closest('[data-sort]');
    if (!option) return;
    const sort = option.dataset.sort;
    document.getElementById('sort-value').textContent = option.textContent;
    menu.querySelectorAll('[data-sort]').forEach((item) => {
      item.setAttribute('aria-checked', String(item === option));
    });
    const notes = Array.from(list.children);
    notes.sort((a, b) => {
      const titleOrder = a.dataset.title.localeCompare(b.dataset.title);
      if (sort === 'title') return titleOrder;
      const dateOrder = Number(a.dataset.date) - Number(b.dataset.date);
      return (sort === 'oldest' ? dateOrder : -dateOrder) || titleOrder;
    });
    list.append(...notes);
  });
})();
