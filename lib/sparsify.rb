# encoding: utf-8

module Sparsify
  def self.sparse source
    sparsey source, :flatten
  end

  def self.unsparse source
    result = {}
    obj_keys = source.keys.select{|k| k.include?('.')}

    top_level = obj_keys.map{|o| o.split('.').first}.uniq

    top_level.each do |t|
      result[t] = {}
    end

    source.each do |k,v|
      if k.count('.') > 1
        keys = k.split('.')
        one = keys.first
        result[one][keys[1]] = {} if result[one][keys[1]].nil?
        result[one][keys[1]].merge!( {keys[2] => v})
      elsif k.count('.') == 1
        result[k.split('.').first][k.split('.')[1]] = v
      else
        result.merge!({k => v})
      end
    end

    result
  end

private

  def self.sparsey source, method
    result = {}
    source.each do |k,v|
      result.merge!(send(method,k,v))
    end
    result
  end

  def self.flatten k,v
    if v.kind_of? Hash
      res = {}
      v.each do |ki, vi|
        res.merge!(flatten "#{k}.#{ki}", vi)
      end
      res
    else
      {k => v}
    end
  end

  def self.unflatten k,v,res

  end

end
