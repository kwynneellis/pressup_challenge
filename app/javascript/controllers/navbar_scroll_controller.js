import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["activeItem", "container"];

  connect() {
    this.centerOnActiveItem();
  }

  centerOnActiveItem() {
    this.scrollToActiveItem(this.activeItemTarget);
  }

  scrollToActiveItem(activeItem) {
    const container = this.containerTarget;

    if (activeItem) {
      const containerWidth = container.clientWidth;
      const activeItemPosition = activeItem.offsetLeft - (containerWidth / 2) + (activeItem.clientWidth / 2);

      container.scrollLeft = activeItemPosition;
    }
  }

  setActiveItem(event) {
    // Remove 'active' class from all items
    this.containerTarget.querySelectorAll('.scroll-item').forEach(item => {
      item.classList.remove('active');
    });

    // Add 'active' class to the clicked item
    const clickedItem = event.currentTarget;
    clickedItem.classList.add('active');

    // Keep the scrollbar as it is, without centering again
    // this.scrollToActiveItem(clickedItem);
  }
}