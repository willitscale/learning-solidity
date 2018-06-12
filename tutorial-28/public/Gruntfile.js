module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    browserify: {
      js: {
        src: 'src/scripts/*.js',
        dest: 'build/scripts/app.js',
      },
    },
    jshint: {
      all: ['Gruntfile.js', 'src/**/*.js'],
      options: {
        esversion: 6
      }
    },
    copy: {
      all: {
        expand: true,
        cwd: 'src/',
        src: ['**/*.html', '**/*.css'],
        dest: 'build/',
      },
    },
    watch: {
      scripts: {
        files: ['src/**'],
        tasks: ['jshint','browserify','copy'],
        options: {
          spawn: false,
        },
      }
    },
    connect: {
      server: {
        options: {
          port: 8000,
          hostname: '*',
          base: './build/'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-jshint');

  grunt.registerTask('default', ['jshint','browserify','copy','connect:server','watch']);
};
