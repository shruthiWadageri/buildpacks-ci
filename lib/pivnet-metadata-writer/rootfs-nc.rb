
class PivnetMetadataWriter::RootfsNC < PivnetMetadataWriter

  attr_reader :output_dir

  def initialize(output_dir)
    @output_dir = output_dir
  end


  def run!
    metadata_yml = File.join(output_dir, 'rootfs-nc.yml')

    metadata = {}

    puts "Writing metadata to #{metadata_yml}"
    puts metadata.to_yaml
    puts "\n\n"

    File.write(metadata_yml, metadata.to_yaml)
  end
end


