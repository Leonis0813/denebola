# coding: utf-8

require 'spec_helper'

describe CollectUtil do
  fixtures = File.join(APPLICATION_ROOT, 'spec', 'fixtures')

  before(:all) { CollectUtil.logger = DenebolaLogger.new('/dev/null') }

  describe '.get_race_ids' do
    describe '正常系' do
      context 'ファイルが存在する場合' do
        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            race_ids = File.read(File.join(fixtures, 'race_ids_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(race_ids, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            race_ids_file = File.join(fixtures, 'race_ids_from_file.txt')
            @response = CollectUtil.get_race_ids(race_ids_file, '20000101')
          end
        end

        it 'ファイルから取得していること' do
          is_asserted_by { @response == ['race ids from file'] }
        end
      end

      context 'ファイルが存在しない場合' do
        race_ids_file = File.join(fixtures, 'not-exist')

        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            race_ids = File.read(File.join(fixtures, 'race_ids_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(race_ids, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            @response = CollectUtil.get_race_ids(race_ids_file, '20000101')
          end
        end

        after(:all) { FileUtils.rm(race_ids_file) }

        it 'リモートから取得していること' do
          is_asserted_by { @response == ['20000101'] }
        end

        it 'リモートから取得したファイルを保存していること' do
          is_asserted_by { File.exists?(race_ids_file) }
        end

        it 'ファイルの内容が正しいこと' do
          is_asserted_by { File.read(race_ids_file) == '20000101' }
        end
      end
    end
  end

  describe '.get_race_html' do
    describe '正常系' do
      context 'ファイルが存在する場合' do
        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            race_html = File.read(File.join(fixtures, 'race_html_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(race_html, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            race_html_file = File.join(fixtures, 'race_html_from_file.txt')
            @response = CollectUtil.get_race_html(race_html_file, '20000101')
          end
        end

        it 'ファイルから取得していること' do
          is_asserted_by { @response == "race html from file\n" }
        end
      end

      context 'ファイルが存在しない場合' do
        race_html_file = File.join(fixtures, 'not-exist')

        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            race_html = File.read(File.join(fixtures, 'race_html_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(race_html, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            @response = CollectUtil.get_race_html(race_html_file, '20000101')
          end
        end

        after(:all) { FileUtils.rm(race_html_file) }

        it 'リモートから取得していること' do
          is_asserted_by { @response == "race html from remote\n" }
        end

        it 'リモートから取得したファイルを保存していること' do
          is_asserted_by { File.exists?(race_html_file) }
        end

        it 'ファイルの内容が正しいこと' do
          is_asserted_by { File.read(race_html_file) == "race html from remote\n" }
        end
      end
    end
  end

  describe '.get_horse_html' do
    describe '正常系' do
      context 'ファイルが存在する場合' do
        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            horse_html = File.read(File.join(fixtures, 'horse_html_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(horse_html, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            horse_html_file = File.join(fixtures, 'horse_html_from_file.txt')
            @response = CollectUtil.get_horse_html(horse_html_file, '20000101')
          end
        end

        it 'nilを返していること' do
          is_asserted_by { @response.nil? }
        end
      end

      context 'ファイルが存在しない場合' do
        horse_html_file = File.join(fixtures, 'not-exist')

        before(:all) do
          RSpec::Mocks.with_temporary_scope do
            horse_html = File.read(File.join(fixtures, 'horse_html_from_remote.txt'))
            struct = Struct.new(:body, :code)
            response = struct.new(horse_html, 200)
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response)
            @response = CollectUtil.get_horse_html(horse_html_file, '20000101')
          end
        end

        after(:all) { FileUtils.rm(horse_html_file) }

        it 'リモートから取得したファイルを保存していること' do
          is_asserted_by { File.exists?(horse_html_file) }
        end

        it 'ファイルの内容が正しいこと' do
          is_asserted_by { File.read(horse_html_file) == "horse html from remote\n" }
        end
      end
    end
  end
end
