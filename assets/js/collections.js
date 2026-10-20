(() => {
  const input = document.getElementById('collection-search');
  const cards = Array.from(document.querySelectorAll('#collection-grid .note-collection'));
  if (!input) return;

  document.getElementById('collection-search-control').hidden = false;
  input.addEventListener('input', () => {
    const query = input.value.trim().toLocaleLowerCase();
    cards.forEach((card) => {
      card.hidden = !card.dataset.title.toLocaleLowerCase().includes(query);
    });
    document.getElementById('collection-empty').hidden = cards.some((card) => !card.hidden);
  });
})();
