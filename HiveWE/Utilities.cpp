#include "stdafx.h"

QOpenGLFunctions_4_5_Core* gl;
Shapes shapes;

void Shapes::init() {
	gl->glCreateBuffers(1, &vertex_buffer);
	gl->glNamedBufferData(vertex_buffer, quad_vertices.size() * sizeof(glm::vec2), quad_vertices.data(), GL_STATIC_DRAW);

	gl->glCreateBuffers(1, &index_buffer);
	gl->glNamedBufferData(index_buffer, quad_indices.size() * sizeof(unsigned int) * 3, quad_indices.data(), GL_STATIC_DRAW);
}

std::vector<std::string> split(const std::string& string, const char delimiter) {
	std::vector<std::string> elems;
	std::stringstream ss(string);

	std::string item;
	while (std::getline(ss, item, delimiter)) {
		elems.push_back(item);
	}
	return elems;
}

std::vector<std::string_view> split_new(const std::string& string, const char delimiter) {
	std::vector<std::string_view> elems;

	int last_position = 0;
	for (int i = 0; i < string.length(); i++) {
		if (string[i] == delimiter) {
			elems.emplace_back(string.c_str() + last_position, i - last_position);
			last_position = i;
		}
	}

	if (elems.empty()) {
		elems.emplace_back(string);
	}

	return elems;
}

bool is_number(const std::string& s) {
	return !s.empty() && std::find_if(s.begin(), s.end(), [](char c) { return !std::isdigit(c); }) == s.end();
}

GLuint compile_shader(const fs::path& vertex_shader, const fs::path& fragment_shader) {
	char buffer[512];
	GLint status;

	std::string vertex_source = read_text_file(vertex_shader.string());
	std::string fragment_source = read_text_file(fragment_shader.string());

	const GLuint vertex = gl->glCreateShader(GL_VERTEX_SHADER);
	const GLuint fragment = gl->glCreateShader(GL_FRAGMENT_SHADER);

	// Vertex Shader
	const char* source = vertex_source.c_str();
	gl->glShaderSource(vertex, 1, &source, nullptr);
	gl->glCompileShader(vertex);


	gl->glGetShaderiv(vertex, GL_COMPILE_STATUS, &status);
	gl->glGetShaderInfoLog(vertex, 512, nullptr, buffer);
	if (!status) {
		std::cout << buffer << std::endl;
	}

	// Fragment Shader
	source = fragment_source.c_str();
	gl->glShaderSource(fragment, 1, &source, nullptr);
	gl->glCompileShader(fragment);

	gl->glGetShaderiv(fragment, GL_COMPILE_STATUS, &status);
	gl->glGetShaderInfoLog(fragment, 512, nullptr, buffer);
	if (!status) {
		std::cout << buffer << std::endl;
	}

	// Link
	const GLuint shader = gl->glCreateProgram();
	gl->glAttachShader(shader, vertex);
	gl->glAttachShader(shader, fragment);
	gl->glLinkProgram(shader);

	gl->glGetProgramiv(shader, GL_LINK_STATUS, &status);
	if (!status) {
		gl->glGetProgramInfoLog(shader, 512, nullptr, buffer);
		std::cout << buffer << std::endl;
	}

	gl->glDeleteShader(vertex);
	gl->glDeleteShader(fragment);

	return shader;
}

std::string read_text_file(const std::string& path) {
	std::ifstream textfile(path.c_str());
	std::string line;
	std::string text;

	if (!textfile.is_open())
		return "";

	while (getline(textfile, line)) {
		text += line + "\n";
	}

	return text;
}

fs::path find_warcraft_directory() {
	QSettings settings;
	if (settings.contains("warcraftDirectory")) {
		return settings.value("warcraftDirectory").toString().toStdString();
	} else if (fs::exists("C:/Program Files (x86)/Warcraft III")) {
		return "C:/Program Files (x86)/Warcraft III";
	} else if (fs::exists("D:/Program Files (x86)/Warcraft III")) {
		return "D:/Program Files (x86)/Warcraft III";
	} else {
		return "";
	}
}

void load_modification_table(BinaryReader& reader, slk::SLK& base_data, slk::SLK& meta_data, const bool modification, bool optional_ints) {
	const uint32_t objects = reader.read<uint32_t>();
	for (size_t i = 0; i < objects; i++) {
		const std::string original_id = reader.read_string(4);
		const std::string modified_id = reader.read_string(4);

		if (modification) {
			base_data.copy_row(original_id, modified_id);
		}

		const uint32_t modifications = reader.read<uint32_t>();

		for (size_t j = 0; j < modifications; j++) {
			const std::string modification_id = reader.read_string(4);
			const uint32_t type = reader.read<uint32_t>();


			std::string column_header = meta_data.data("field", modification_id);

			if (optional_ints) {
				// Level or variation depending on which type of slk provided. ( Abilities / Upgrades or Doodads )
				const uint32_t repeat = reader.read<uint32_t>();
				const uint32_t data_pointer = reader.read<uint32_t>();
				std::string data_id = std::string();

				if (repeat != 0 && data_pointer != 0) {
					switch (data_pointer) {
					case 1:
						data_id.push_back('A');
						break;
					case 2:
						data_id.push_back('B');
						break;
					case 3:
						data_id.push_back('C');
						break;
					case 4:
						data_id.push_back('D');
						break;
					case 5:
						data_id.push_back('F');
						break;
					case 6:
						data_id.push_back('G');
						break;
					case 7:
						data_id.push_back('H');
						break;
					case 8:
						break;
					case 9: 
						break;
					}
					column_header.append(data_id + std::to_string(repeat));
				} else if (repeat > 0 && data_pointer == 0){
					if ( !std::isdigit(meta_data.data("ID", modification_id).back()) ) {
						column_header.append(std::to_string(repeat));
					} 
				}
			}

			std::string data;
			switch (type) {
				case 0:
					data = std::to_string(reader.read<int>());
					break;
				case 1:
					data = std::to_string(reader.read<float>());
					break;
				case 2:
					data = std::to_string(reader.read<float>());
					break;
				case 3:
					data = reader.read_c_string();
					break;
				default: 
					std::cout << "Unknown data type " << type << " while loading modification table.";
			}
			reader.position += 4;
			if (modification) {
				base_data.set_shadow_data(column_header, modified_id, data);
			} else {
				base_data.set_shadow_data(column_header, original_id, data);
			}
		}
	}
}

QIcon ground_texture_to_icon(uint8_t* data, const int width, const int height) {
	QImage temp_image = QImage(data, width, height, QImage::Format::Format_ARGB32);
	const int size = height / 4;

	auto pix = QPixmap::fromImage(temp_image.copy(0, 0, size, size));

	QIcon icon;
	icon.addPixmap(pix, QIcon::Normal, QIcon::Off);

	QPainter painter(&pix);
	painter.fillRect(0, 0, size, size, QColor(255, 255, 0, 64));
	painter.end();

	icon.addPixmap(pix, QIcon::Normal, QIcon::On);

	return icon;
}

QIcon texture_to_icon(fs::path path) {
	auto tex = resource_manager.load<Texture>(path);
	QImage temp_image = QImage(tex->data.data(), tex->width, tex->height, QImage::Format::Format_ARGB32);
	auto pix = QPixmap::fromImage(temp_image);
	return QIcon(pix);
};