# encoding: utf-8

module Sparsify
  def self.sparse source, h={separator: '.'}
    separator = h[:separator]
    result = {}
    source.each do |k,v|
      k = k.gsub(separator, "\\#{separator}")
      result.merge!(flatten k,v,separator )
    end
    result
  end

  def self.unsparse source, h={separator: '.'}
    separator = h[:separator]
    #return unflatten source, separator
    result = {}
    obj_keys = source.keys.select{|k| k.include?(separator)}

    top_level = obj_keys.map{|o| o.split(/(?<!\\)#{Regexp.escape(separator)}/).first}.uniq.map{|k| k.gsub("\\#{separator}", separator)}


    top_level.each do |t|
      result[t] = {}
    end

    source.each do |k,v|
      if k.include?(separator)
        if k.count(separator) > 1
          keys = k.split(/(?<!\\)#{Regexp.escape(separator)}/).map{|k| k.gsub("\\#{separator}", separator)}
          one = keys.first
          result[one] = {} if result[one].nil?
          result[one][keys[1]] = v and next if keys.size == 2 
          result[one][keys[1]] = {} if result[one][keys[1]].nil?
          result[one][keys[1]].merge!( {keys[2] => v})
        elsif k.count(separator) == 1
          result[k.split(separator).first][k.split(separator)[1]] = v
        end
      else 
        result.merge!({k => v})
      end
    end

    keys = result.keys
    values = result.values
    result = {}
    keys.each_with_index do |k,i|
      v = values[i]
      key = k.gsub("\\", "\\\\")
      result[key] = v
    end
    result
  end

private

  def self.flatten k, v, separator
    if v.kind_of?(Hash) && !v.empty?
      res = {}
      v.each do |ki, vi|
        res.merge!(flatten "#{k}#{separator}#{ki}", vi, separator)
      end
      res
    else
      {k => v}
    end
  end

  def self.unflatten source, separator
    result = {}
    keys = source.keys
    values = source.values
    keys.each_with_index do |k, i|
      layer_keys = k.split(/(?<!\\)#{Regexp.escape(separator)}/)
      layer_keys.reverse!
      first = layer_keys.pop
      result = {first => values[i]}
      layer_keys.each do |key|
        result[key] = {} if result[key].nil?
        result[key].merge!(v)
        v = {key => result[key]}
      end
    end
    result
  end

  ## the key

end
