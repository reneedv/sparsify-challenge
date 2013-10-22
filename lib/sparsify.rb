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
    result = {}
    obj_keys = source.keys.select{|k| k.include?(separator)}

    top_level = obj_keys.map{|o| o.split(separator).first}.uniq

    top_level.each do |t|
      result[t] = {}
    end

    source.each do |k,v|
      if k.include?(separator) && !k.include?("\\#{separator}")
        if k.count(separator) > 1
          keys = k.split(separator)
          one = keys.first
          result[one][keys[1]] = {} if result[one][keys[1]].nil?
          result[one][keys[1]].merge!( {keys[2] => v})
        elsif k.count(separator) == 1
          result[k.split(separator).first][k.split(separator)[1]] = v
        end
      else
        result.merge!({k => v})
      end
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

end
