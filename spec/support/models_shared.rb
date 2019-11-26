# coding: utf-8

shared_examples '正常な値を指定した場合のテスト' do |valid_attribute|
  CommonHelper.generate_test_case(valid_attribute).each do |attribute|
    it "#{attribute}を指定した場合、エラーにならないこと" do
      object = build(described_class.name.underscore.downcase.to_sym, attribute)
      object.validate
      is_asserted_by { object.errors.empty? }
    end
  end
end

shared_examples '必須パラメーターがない場合のテスト' do |absent_keys|
  absent_keys.each do |absent_key|
    it "#{absent_key}がない場合、absentエラーになること" do
      attribute = build(described_class.name.underscore.downcase.to_sym)
                  .attributes.except(absent_key.to_s)
      object = described_class.new(attribute)
      object.validate

      is_asserted_by { object.errors.present? }
      is_asserted_by { object.errors.messages[absent_key].include?('absent') }
    end
  end
end

shared_examples '不正な値を指定した場合のテスト' do |invalid_attribute|
  CommonHelper.generate_test_case(invalid_attribute).each do |attribute|
    it "#{attribute}を指定した場合、エラーになること" do
      object = build(described_class.name.underscore.downcase.to_sym, attribute)
      object.validate

      is_asserted_by { object.errors.present? }

      attribute.keys.each do |invalid_key|
        is_asserted_by { object.errors.messages[invalid_key].include?('invalid') }
      end
    end
  end
end

shared_examples '.create_or_update!: データが既に存在する場合のテスト' do |attribute, unique_keys|
  [
    ['create', {}],
    ['update', attribute],
    ['upsert', attribute],
  ].each do |operation, updated_attribute|
    context "operation: #{operation}の場合" do
      include_context 'トランザクション作成'
      before(:all) do
        ApplicationRecord.operation = operation
        resource = create(described_class.to_s.downcase.to_sym)
        @before_count = described_class.count
        @expected_resource = resource.attributes.merge(updated_attribute)
        @target_resource = described_class.create_or_update!(
          resource.attributes.slice(*unique_keys).merge(updated_attribute).except(
            'id',
            'created_at',
            'updated_at',
          ),
        )
      end

      it '新しく作成されていないこと' do
        is_asserted_by { described_class.count == @before_count }
      end

      it '登録済みデータの値が正しいこと' do
        is_asserted_by { @target_resource.attributes == @expected_resource }
      end
    end
  end
end

shared_examples '.create_or_update!: データが存在しない場合のテスト' do
  [
    ['create', 1],
    ['update', 0],
    ['upsert', 1],
  ].each do |operation, additional_count|
    context "operation: #{operation}の場合" do
      include_context 'トランザクション作成'
      before(:all) do
        ApplicationRecord.operation = operation
        @before_count = described_class.count
        described_class.create_or_update!(
          build(described_class.to_s.downcase.to_sym).attributes.except(
            'id',
            'created_at',
            'updated_at',
          ),
        )
      end

      it '登録されているデータの数が正しいこと' do
        is_asserted_by { described_class.count == @before_count + additional_count }
      end
    end
  end
end

shared_examples '.log_attribute: 返り値が正しいこと' do
  %w[create update upsert].each do |operation|
    context "operation: #{operation}の場合" do
      before(:all) do
        @expected = {action: operation, resource: described_class.to_s.downcase}
        ApplicationRecord.operation = operation
      end

      it do
        is_asserted_by { described_class.log_attribute == @expected }
      end
    end
  end
end
