
class PivnetMetadataWriter::RootfsNC < PivnetMetadataWriter

  attr_reader :output_dir, :stack_version, :release_version

  def initialize(output_dir, stack_version, release_version)
    @output_dir = output_dir
    @stack_version = stack_version
    @release_version = release_version
  end


  def run!
    metadata_yml = File.join(output_dir, 'rootfs-nc.yml')

    metadata = {}

    metadata_release = {}
    metadata_release['version'] = "Compilerless RootFS v#{stack_version}"
    metadata_release['release_type'] = 'Beta Release'
    metadata_release['eula_slug'] = 'pivotal_beta_eula'
    metadata_release['availability'] = 'Selected User Groups Only'



    metadata_files = []
    stack = { 'file' => "stack-s3/rootfs-nc/cflinuxfs2_nc-#{stack_version}.tar.gz",
              'upload_as' => "Compilerless RootFS",
              'description' => 'Compilerless RootFS for PCF'
    }
    release = { 'file' => "bosh-release-s3/cflinuxfs2-nc/cflinuxfs2-nc-rootfs-#{release_version}.tgz",
              'upload_as' => "BOSH release of Compilerless RootFS",
              'description' => 'BOSH release of Compilerless RootFS for PCF'
    }
    metadata_files.push stack
    metadata_files.push release
    metadata['product_files'] = metadata_files


    puts "Writing metadata to #{metadata_yml}"
    puts metadata.to_yaml
    puts "\n\n"

    File.write(metadata_yml, metadata.to_yaml)
  end
end


