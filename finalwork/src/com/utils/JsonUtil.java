package com.utils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import org.codehaus.jackson.map.DeserializationConfig.Feature;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.annotate.JsonSerialize.Inclusion;
import org.codehaus.jackson.type.TypeReference;

@SuppressWarnings("unchecked")
public final class JsonUtil {

	private static ObjectMapper MAPPER;

	static {
		MAPPER = generateMapper(Inclusion.ALWAYS);
	}

	private JsonUtil() {
	}

	/**
	 * ��jsonͨ������ת���ɶ���
	 * 
	 * <pre>
	 *     {@link JsonUtil JsonUtil}.fromJson("{\"username\":\"username\", \"password\":\"password\"}", User.class);
	 * </pre>
	 * 
	 * @param json
	 *            json�ַ�
	 * @param clazz
	 *            ��������
	 * @return ���ض���
	 * @throws IOException
	 */
	public static <T> T fromJson(String json, Class<T> clazz)
			throws IOException {
		return clazz.equals(String.class) ? (T) json : MAPPER.readValue(json,
				clazz);
	}

	/**
	 * ��jsonͨ������ת���ɶ���
	 * 
	 * <pre>
	 *     {@link JsonUtil JsonUtil}.fromJson("[{\"username\":\"username\", \"password\":\"password\"}, {\"username\":\"username\", \"password\":\"password\"}]", new TypeReference&lt;List&lt;User&gt;&gt;);
	 * </pre>
	 * 
	 * @param json
	 *            json�ַ�
	 * @param typeReference
	 *            ��������
	 * @return ���ض���
	 * @throws IOException
	 */
	public static <T> T fromJson(String json, TypeReference<?> typeReference)
			throws IOException {
		return (T) (typeReference.getType().equals(String.class) ? json
				: MAPPER.readValue(json, typeReference));
	}

	/**
	 * ������ת����json
	 * 
	 * @param src
	 *            ����
	 * @return ����json�ַ�
	 * @throws IOException
	 */
	public static <T> String toJson(T src) throws IOException {
		return src instanceof String ? (String) src : MAPPER
				.writeValueAsString(src);
	}

	/**
	 * ������ת����json, ���������������
	 * 
	 * <pre>
	 *     {@link JsonUtil JsonUtil}.toJson(user, {@link Inclusion Inclusion.ALWAYS});
	 * </pre>
	 * 
	 * {@link Inclusion Inclusion ����ö��}
	 * <ul>
	 * <li>{@link Inclusion Inclusion.ALWAYS ȫ������}</li>
	 * <li>{@link Inclusion Inclusion.NON_DEFAULT �ֶκͶ���Ĭ��ֵ��ͬ��ʱ�򲻻�����}</li>
	 * <li>{@link Inclusion Inclusion.NON_EMPTY �ֶ�ΪNULL����""��ʱ�򲻻�����}</li>
	 * <li>{@link Inclusion Inclusion.NON_NULL �ֶ�ΪNULLʱ�򲻻�����}</li>
	 * </ul>
	 * 
	 * @param src
	 *            ����
	 * @param inclusion
	 *            ����һ��ö��ֵ, �����������
	 * @param properties
	 *            Ҫ���˵�������ƣ������ش�����ֵ��
	 * @return ����json�ַ�
	 * @throws IOException
	 */
	public static <T> String toJson(T src, Inclusion inclusion)
			throws IOException {
		if (src instanceof String) {
			return (String) src;
		} else {
			ObjectMapper customMapper = generateMapper(inclusion);
			// FilterProvider filterProvider = new
			// SimpleFilterProvider().addFilter("jsonFilter",
			// SimpleBeanPropertyFilter.serializeAllExcept(properties));
			// customMapper.setFilters(filterProvider);
			return customMapper.writeValueAsString(src);
		}
	}

	/**
	 * ������ת����json, �������ö���
	 * 
	 * <pre>
	 *     {@link ObjectMapper ObjectMapper} mapper = new ObjectMapper();
	 *     mapper.setSerializationInclusion({@link Inclusion Inclusion.ALWAYS});
	 *     mapper.configure({@link Feature Feature.FAIL_ON_UNKNOWN_PROPERTIES}, false);
	 *     mapper.configure({@link Feature Feature.FAIL_ON_NUMBERS_FOR_ENUMS}, true);
	 *     mapper.setDateFormat(new {@link SimpleDateFormat SimpleDateFormat}("yyyy-MM-dd HH:mm:ss"));
	 *     {@link JsonUtil JsonUtil}.toJson(user, mapper);
	 * </pre>
	 * 
	 * {@link ObjectMapper ObjectMapper}
	 * 
	 * @see ObjectMapper
	 * 
	 * @param src
	 *            ����
	 * @param mapper
	 *            ���ö���
	 * @return ����json�ַ�
	 * @throws IOException
	 */
	public static <T> String toJson(T src, ObjectMapper mapper)
			throws IOException {
		if (null != mapper) {
			if (src instanceof String) {
				return (String) src;
			} else {
				return mapper.writeValueAsString(src);
			}
		} else {
			return null;
		}
	}

	/**
	 * ����{@link ObjectMapper ObjectMapper}����, ���ڶ����ԵĲ���
	 * 
	 * @return {@link ObjectMapper ObjectMapper}����
	 */
	public static ObjectMapper mapper() {
		return MAPPER;
	}

	/**
	 * ͨ��Inclusion����ObjectMapper����
	 * 
	 * {@link Inclusion Inclusion ����ö��}
	 * <ul>
	 * <li>{@link Inclusion Inclusion.ALWAYS ȫ������}</li>
	 * <li>{@link Inclusion Inclusion.NON_DEFAULT �ֶκͶ���Ĭ��ֵ��ͬ��ʱ�򲻻�����}</li>
	 * <li>{@link Inclusion Inclusion.NON_EMPTY �ֶ�ΪNULL����""��ʱ�򲻻�����}</li>
	 * <li>{@link Inclusion Inclusion.NON_NULL �ֶ�ΪNULLʱ�򲻻�����}</li>
	 * </ul>
	 * 
	 * @param inclusion
	 *            ����һ��ö��ֵ, �����������
	 * @return ����ObjectMapper����
	 */
	public static ObjectMapper generateMapper(Inclusion inclusion) {

		ObjectMapper customMapper = new ObjectMapper();

		// �������ʱ�����Եķ��
		customMapper.setSerializationInclusion(inclusion);

		// ��������ʱ������JSON�ַ��д��ڵ�Java����ʵ��û�е�����
		customMapper.configure(Feature.FAIL_ON_UNKNOWN_PROPERTIES, false);

		// ��ֹʹ��int���Enum��order()�?���л�Enum,�ǳ�Σ�U
		customMapper.configure(Feature.FAIL_ON_NUMBERS_FOR_ENUMS, true);

		// �������ڸ�ʽ��ͳһΪ������ʽ
		customMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));

		return customMapper;
	}

	public static String sucJsonResp(Object data) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("code", 1);
		resultMap.put("data", data);
		try {
			return toJson(resultMap);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static String failJsonResp(String msg) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("code", 0);
		resultMap.put("msg", msg);
		try {
			return toJson(resultMap);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
}