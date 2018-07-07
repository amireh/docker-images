require 'spec_helper'

RSpec.describe DVS::Volumes do
  describe '.from' do
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

    it 'parses volumes with no patterns' do
      described_class.from('foo').first.tap do |volume|
        expect(volume.name).to eq('foo')
      end
    end

    it 'parses a volume with a path' do
      described_class.from('foo/bar', base: file_tree.root).first.tap do |volume|
        expect(volume.files.length).to eq(1)
        expect(volume.files).to eq(%w[ bar ])
      end
    end

    it 'accepts a pattern for a path' do
      described_class.from('foo/*', base: file_tree.root).first.tap do |volume|
        expect(volume.files.length).to eq(2)
        expect(volume.files.sort).to eq(%w[ bar baz ])
      end
    end

    it 'parses a volume with multiple paths' do
      described_class.from('foo/bar,foo/baz', base: file_tree.root).first.tap do |volume|
        expect(volume.files.length).to eq(2)
        expect(volume.files).to eq(%w[ bar baz ])
      end
    end
  end
end