module SQLite3Configuration
  private
    def configure_connection
      super

      if @config[:retries]
        retries = self.class.type_cast_config_to_integer(@config[:retries])
        raw_connection.busy_handler do |count|
          (count <= retries).tap { |result| sleep count * 0.001 if result }
        end
      end

      # Performance tuning for production
      raw_connection.execute("PRAGMA journal_mode = WAL")
      raw_connection.execute("PRAGMA synchronous = normal")
      raw_connection.execute("PRAGMA mmap_size = 134217728") # 128MB
      raw_connection.execute("PRAGMA journal_size_limit = 67108864") # 64MB
      raw_connection.execute("PRAGMA cache_size = -64000") # 64MB
    end
end

ActiveSupport.on_load :active_record do
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.prepend SQLite3Configuration
end
