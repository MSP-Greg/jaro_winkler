require 'minitest/autorun'
require 'jaro_winkler'

class TestJaroWinkler < Minitest::Test
  def test_distance
    assert_distance 0.9667, 'henka',       'henkan'
    assert_distance 1.0,    'al',          'al'
    assert_distance 0.9611, 'martha',      'marhta'
    assert_distance 0.8324, 'jones',       'johnson'
    assert_distance 0.9583, 'abcvwxyz',    'cabvwxyz'
    assert_distance 0.8400, 'dwayne',      'duane'
    assert_distance 0.8133, 'dixon',       'dicksonx'
    assert_distance 0.0,    'fvie',        'ten'
    assert_distance 1.0,    'tony',        'tony'
    assert_distance 1.0,    'tonytonyjan', 'tonytonyjan'
    assert_distance 1.0,    'x',           'x'
    assert_distance 0.0,    '',            ''
    assert_distance 0.0,    'tony',        ''
    assert_distance 0.0,    '',            'tony'
    assert_distance 0.8727, 'tonytonyjan', 'tony'
    assert_distance 0.8727, 'tony',        'tonytonyjan'
  end

  def test_unicode
    assert_distance 0.9818, '變形金剛4:絕跡重生', '變形金剛4: 絕跡重生'
    assert_distance 0.8222, '連勝文',             '連勝丼'
    assert_distance 0.8222, '馬英九',             '馬英丸'
    assert_distance 0.6667, '良い',               'いい'
  end

  def test_ignore_case
    assert_distance 0.9611, 'MARTHA', 'marhta', ignore_case: true
  end

  def test_weight
    assert_distance 0.9778, 'MARTHA', 'MARHTA', weight: 0.2
  end

  def test_threshold
    assert_distance 0.9444, 'MARTHA', 'MARHTA', threshold: 0.99
  end


  def test_adjusting_table
    assert_distance 0.9667, 'HENKA', 'HENKAN', adj_table: true
    assert_distance 1.0, 'AL', 'AL', adj_table: true
    assert_distance 0.9611, 'MARTHA', 'MARHTA', adj_table: true
    assert_distance 0.8598, 'JONES', 'JOHNSON', adj_table: true
    assert_distance 0.9583, 'ABCVWXYZ', 'CABVWXYZ', adj_table: true
    assert_distance 0.8730, 'DWAYNE', 'DUANE', adj_table: true
    assert_distance 0.8393, 'DIXON', 'DICKSONX', adj_table: true
    assert_distance 0.0, 'FVIE', 'TEN', adj_table: true
  end

  def test_error
    assert_raises JaroWinkler::InvalidWeightError do
      JaroWinkler.distance 'MARTHA', 'MARHTA', weight: 0.26
    end
  end

  def test_long_string
    JaroWinkler.distance 'haisai' * 20, 'haisai' * 20
  end

private

  def assert_distance score, str1, str2, **options
    assert_equal score, JaroWinkler.distance(str1, str2, **options).round(4)
  end
end