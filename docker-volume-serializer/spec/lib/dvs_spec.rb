require 'spec_helper'

RSpec.describe DVS do
  describe 'pack' do
    let!(:file_tree) do
      FileTree.create!("
        - foo/
        - foo/bar
        - foo/baz
      ")
    end

    let!(:outdir) { Dir.mktmpdir }

    after(:each) do
      FileUtils.rmtree(file_tree.root)
      FileUtils.rmtree(outdir)
    end

    it 'works' do
      expect {
        subject.pack(
          archive_dir: outdir,
          owner_gid: `id -g`.strip,
          owner_uid: `id -u`.strip,
          volumes: DVS::Volumes.from('foo', base: file_tree.root),
        )
      }.to change {
        File.exist?("#{outdir}/foo.tar")
      }.from(false).to(true)

      expect(`tar -tvf "#{outdir}/foo.tar"`.lines.count).to eq(2)
    end
  end

  describe 'unpack' do
    let!(:file_tree) {
      FileTree.create!("
        - foo/
        - foo/bar
        - foo/baz
      ")
    }

    after(:each) do
      FileUtils.rmtree(file_tree.root)
    end

    it 'works' do
      archive_dir = Dir.mktmpdir
      unpacked_dir = Dir.mktmpdir

      @janitor << lambda {
        FileUtils.rmtree(archive_dir)
        FileUtils.rmtree(unpacked_dir)
      }

      FileUtils.mkdir_p("#{unpacked_dir}/foo")

      subject.pack(
        archive_dir: archive_dir,
        owner_gid: `id -g`.strip,
        owner_uid: `id -u`.strip,
        volumes: DVS::Volumes.from('foo', base: file_tree.root),
      )

      expect {
        subject.unpack(
          archive_dir: archive_dir,
          owner_gid: `id -g`.strip,
          owner_uid: `id -u`.strip,
          volumes: DVS::Volumes.from('foo', base: unpacked_dir)
        )
      }.to change {
        Dir.glob("#{unpacked_dir}/foo/*").count
      }.from(0).to(2)
    end
  end
end
