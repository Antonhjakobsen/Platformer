class Animation {
  PImage[] images;
  int imageCount;
  int frame;

  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];
    for (int i = 0; i < imageCount; i++) {
      // Load images named, for example, "label0.gif", "label1.gif"
      images[i] = loadImage(imagePrefix + i + ".gif");
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame + 1) % imageCount; // Loop through frames
    image(images[frame], xpos, ypos);
  }
}
