module FilesTestHelper
  extend self
  extend ActionDispatch::TestProcess

  def png_name; 'test-image.png' end
  def png; upload(png_name, 'image/png') end

  def jpg_name; 'test-image.jpg' end
  def jpg; upload(jpg_name, 'image/jpg') end

  def tiff_name; 'test-image.tiff' end
  def tiff; upload(tiff_name, 'image/tiff') end

  def pdf_name; 'test.pdf' end
  def pdf; upload(pdf_name, 'application/pdf') end

  private

  def upload(name, type)
    file_path = Rails.root.join('spec', 'support', 'assets', name)
    fixture_file_upload(file_path, type)
  end
end
