puts "[.pryrc 読み込まれました！ - 最強テーブル表示 & クエリカウントモード🔥]"

# --------------------------------------------
# テーブル表示関数（超便利 show）
# --------------------------------------------
def show(records, fields = nil)
  return puts "No records!" if records.empty?

  fields ||= records.first.attribute_names.map(&:to_sym)

  header = fields.map { |f| f.to_s.ljust(20) }.join(" | ")
  puts header
  puts "-" * header.length

  records.each do |record|
    row = fields.map { |f| record.send(f).to_s.ljust(20) rescue ''.ljust(20) }.join(" | ")
    puts row
  end
end

# --------------------------------------------
# クエリ発行カウント機能
# --------------------------------------------

$queries = []

ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, payload|
  unless payload[:name] == "SCHEMA"
    $queries << payload[:sql]
  end
end

def show_queries
  puts "\n📊 発行されたクエリ数: #{$queries.size}"
  $queries.each_with_index do |sql, i|
    puts "#{i + 1}. #{sql}"
  end
end

def reset_queries
  $queries.clear
  puts "🔄 クエリ履歴をリセットしました"
end